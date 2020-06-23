# frozen_string_literal: true

class Api::V01::BibsController < Api::V01::GeneralController
  include LogWrapper
  include TeacherSetsHelper

  before_action :set_request_body
  before_action :validate_source_of_request

  # Receive teacher sets from a POST request.
  # All records are inside @request_body.
  # Find or create a teacher set in the MLN db and its associated books.
  PREK_ARR = ['PRE K', 'PRE-K', 'PREK'].freeze
  def create_or_update_teacher_sets
    LogWrapper.log('DEBUG', {'message' => 'create_or_update_teacher_sets.start','method' => 'bibs_controller.create_or_update_teacher_sets'})

    error_code_and_message = validate_request
    if error_code_and_message.any?
      AdminMailer.failed_bibs_controller_api_request(@request_body, error_code_and_message, action_name, nil).deliver
      render_error(error_code_and_message)
    end
    return if error_code_and_message.any?

    saved_teacher_sets = []
    @request_body.each do |teacher_set_record|
      # overwrite @teacher_set_record instance variable so it can be read in the var_field and fixed_field methods
      @teacher_set_record = teacher_set_record

      # validate each teacher_set_record
      bnumber = teacher_set_record['id']
      title = teacher_set_record['title']
      physical_description = var_field('300')

      if bnumber.blank? || title.blank? || physical_description.blank?
        AdminMailer.teacher_set_update_missing_required_fields(bnumber, title, physical_description).deliver
        log_error('create_or_update_teacher_sets', StandardError.new("create_or_update_teacher_sets cannot update bib \
          with missing bnumber (#{bnumber || 'nil'}), \
          title (#{title || 'nil'}) or physical_description (#{physical_description || 'nil'})."))
        next
      end

      teacher_set = TeacherSet.where(bnumber: "b#{bnumber}").first_or_initialize

      # Calls Bib service for items.
      # Calculates the total number of items and available items in the list.
      ts_items_info = teacher_set.get_items_info_from_bibs_service(bnumber)

      begin
        teacher_set.update_attributes(
          title: title,
          call_number: var_field('091'),
          description: var_field('520'),
          edition: var_field('250'),
          isbn: var_field('020'),
          primary_language: fixed_field('24'),
          publisher: var_field('260'),
          contents: var_field('505'),
          area_of_study: var_field('690', false),
          physical_description: physical_description,
          details_url: "http://catalog.nypl.org/record=b#{teacher_set_record['id']}~S1",
          # If Grade value is Pre-K saves as -1 and Grade value is 'K' saves as '0' in TeacherSet table.
          grade_begin: grade_or_lexile_array('grade')[0] || '',
          grade_end: grade_or_lexile_array('grade')[1] || '',
          lexile_begin: grade_or_lexile_array('lexile')[0] || '', # NOTE: lexile functionality has been taken off
          lexile_end: grade_or_lexile_array('lexile')[1] || '', # NOTE: lexile functionality has been taken off
          available_copies: ts_items_info[:available_count],
          total_copies: ts_items_info[:total_count],
          availability: ts_items_info[:availability_string]
        )
      rescue => exception
        log_error('create_or_update_teacher_sets', exception)
        AdminMailer.failed_bibs_controller_api_request(
          @request_body, "One attribute may be too long.  Error: #{exception.message[0..200]}...", action_name, teacher_set
        ).deliver
      end
      begin
        # clean up the area of study field to match the subject field string rules
        teacher_set.clean_primary_subject()
      rescue => exception
        log_error('clean_primary_subject', exception)
        AdminMailer.failed_bibs_controller_api_request(
          @request_body, "Error updating primary subject via API: #{exception.message[0..200]}...", action_name, teacher_set
        ).deliver
      end
      begin
        teacher_set.update_subjects_via_api(all_var_fields('650', 'a'))
      rescue => exception
        log_error('create_or_update_teacher_sets', exception)
        AdminMailer.failed_bibs_controller_api_request(
          @request_body, "Error updating subjects via API: #{exception.message[0..200]}...", action_name, teacher_set
        ).deliver
      end
      begin
        teacher_set.update_notes(var_field('500', true))
      rescue => exception
        log_error('create_or_update_teacher_sets', exception)
        AdminMailer.failed_bibs_controller_api_request(
          @request_body, "Error updating notes via API: #{exception.message[0..200]}...", action_name, teacher_set
        ).deliver
      end
      begin
        # Set type value varFields entry with the marcTag=526
        teacher_set.update_included_book_list(teacher_set_record, var_field('526'))
      rescue => exception
        log_error('create_or_update_teacher_sets', exception)
        AdminMailer.failed_bibs_controller_api_request(
          @request_body, "Error updating the associated book records via API: #{exception.message[0..200]}...", action_name, teacher_set
        ).deliver
      end

      # Feature flag: 'teacherset.data.from.elasticsearch.enabled = true'.
      # If feature flag is enabled create/update data in elasticsearch.
      if MlnConfigurationController.new.feature_flag_config('teacherset.data.from.elasticsearch.enabled')
        begin
          # When ever there is a create/update on bib than need to create/update the data in elastic search document.
          create_or_update_teacherset_document_in_es(TeacherSet.find(teacher_set.id))
        rescue => exception
          log_error('create_or_update_teacher_sets', exception)
        end
      end
      saved_teacher_sets << teacher_set
      LogWrapper.log('INFO', {'message' => "create_or_update_teacher_sets:finished making teacher set.
                     Teacher set availableCount: #{ts_items_info[:available_count]}, totalCount: #{ts_items_info[:total_count]}",
                     'method' => "bibs_controller.create_or_update_teacher_sets"})
    end
    api_response_builder(200, { teacher_sets: saved_teacher_sets_json_array(saved_teacher_sets) }.to_json)
  end


  def delete_teacher_sets
    error_code_and_message = validate_request
    if error_code_and_message.any?
      AdminMailer.failed_bibs_controller_api_request(@request_body, error_code_and_message, action_name, nil).deliver
      render_error(error_code_and_message)
      return
    end

    saved_teacher_sets = []
    @request_body.each do |teacher_set_record|
      # Delete teacher-set record by bib_id
      teacher_set = TeacherSet.new.get_teacher_set_by_bnumber(teacher_set_record['id'])
      next unless teacher_set.present?
      saved_teacher_sets << teacher_set
      resp = teacher_set.destroy
      # Feature flag: 'teacherset.data.from.elasticsearch.enabled = true'.
      # If feature flag is enabled delete data from elasticsearch.
      if MlnConfigurationController.new.feature_flag_config('teacherset.data.from.elasticsearch.enabled')
        # After deletion of teacherset data from db than delete teacherset doc from elastic search
        delete_teacherset_record_from_es(teacher_set.id) if resp.destroyed?
      end
    end
    api_response_builder(200, { teacher_sets: saved_teacher_sets_json_array(saved_teacher_sets) }.to_json)
  end


  private


    def var_field(marcTag, merge = true)
      begin
        if merge == true
          @teacher_set_record['varFields'].detect{ |hash| hash['marcTag'] == marcTag }['subfields'].map{ |x| x['content']}.join(', ')
        else
          @teacher_set_record['varFields'].detect{ |hash| hash['marcTag'] == marcTag }['subfields'].detect{ |hash| hash['tag'] == 'a' }['content']
        end
      rescue
        return nil
      end
    end


    def all_var_fields(marcTag, tag)
      begin
        @teacher_set_record['varFields'].select{ |hash| hash['marcTag'] == marcTag }.map{|x| x['subfields'][0]['content']}
      rescue
        return nil
      end
    end


    def fixed_field(marcTag)
      begin
        @teacher_set_record['fixedFields'][marcTag]['display']
      rescue
        return nil
      end
    end


    # build saved_teacher_sets_json_array for the response body
    def saved_teacher_sets_json_array(saved_teacher_sets)
      return [] if saved_teacher_sets.empty?
      saved_teacher_sets_json_array = []
      saved_teacher_sets.each do |saved_ts|
        saved_teacher_sets_json_array << { id: saved_ts.id, bnumber: saved_ts.bnumber, title: saved_ts.title }
      end
      saved_teacher_sets_json_array
    end


    # Grades filter supports Pre-K and K
    # Grades = {Pre-K => -1, K => 0}
    # If Grade value is Pre-K saves as -1 and Grade value is 'K' saves as '0' in TeacherSet table.
    # Parsing lexile begin/end values has been deprecated, and will no longer work as expected.
    def grade_or_lexile_array(return_grade_or_lexile)
        grade_and_lexile_json = all_var_fields('521', 'content')
        return '' if grade_and_lexile_json.blank?
        grades_resp = get_grades(grade_and_lexile_json)
        grades_resp.each do |grade_or_lexile_json|
          begin
            if return_grade_or_lexile == 'lexile' && grade_or_lexile_json.include?('L')
              return grade_or_lexile_json.gsub('Lexile ', '').gsub('L', '').split(' ')[0].split('-')
            elsif return_grade_or_lexile == 'grade' && !grade_or_lexile_json.include?('L')
              if grade_or_lexile_json.upcase.include?('PRE')
                # Prek values: ['PRE K', 'pre k', 'PRE-K', 'pre-k', 'Pre-K', 'Pre K', 'PreK', 'prek'] - supporting these values only
                PREK_ARR.each do |val|
                  grades = grade_or_lexile_json.upcase.gsub('.', '').split("#{val}-")
                  return [TeacherSet::PRE_K_VAL, grade_val(grades[1])] if grades.length > 1
                end
              elsif grade_or_lexile_json.upcase.include?('K')
                # K values: [K, k] - supporting these values only
                grade = grade_or_lexile_json.upcase.gsub('.', '').split('K-')[1]
                return [TeacherSet::K_VAL, grade_val(grade)]
              else
                return grade_or_lexile_json.gsub('.', '').split('-')
              end
            elsif grade_or_lexile_json.upcase.include?('K')
              # K values: [K, k] - supporting these values only
              grade = grade_or_lexile_json.upcase.gsub('.', '').split('K-')[1]
              return [TeacherSet::K_VAL, grade_val(grade)]
            else
              return grade_or_lexile_json.gsub('.', '').split('-')
            end
          end
        rescue
          []
        end
    end


    # Supporting only below grades
    GRADES_1_12 = %w[1 2 3 4 5 6 7 8 9 10 11 12].freeze
    PREK_K_GRADES = ['PRE K', 'pre k', 'PRE-K', 'pre-k', 'Pre-K', 'Pre K', 'PreK', 'prek', 'K', 'k'].freeze

    # "marcTag": "521" {"tag": "a", "content": "11-12" } if field does not match with grades returns 'Pre-K +'.
    # eg: ["dd", "11-444", "Z", "1130L"] -  only 11 is matched with supporting grades. It returns 11 +
    # eg: ["9", "11-444", "Z", "1130L"] -  9 and 11 matched with supporting grades. It returns 9 +
    # eg: ["9", "114-4", "Z", "1130L"] -  4 matched with supporting grades. It returns 4 +
    def get_grades(grade_and_lexile_json)
      grades = GRADES_1_12 + PREK_K_GRADES
      grades_arr = []
      prek_arr = []
      grade_and_lexile_json.each do |gd|
        grade = gd.strip()
        return [grade] if grade.upcase.include?('PRE')
        grade_arr = grade.gsub('.', '').split('-')
        if grades.include?(grade_arr[0]) && grades.include?(grade_arr[1])
          grades_arr << grade
          return grades_arr
        elsif !grades.include?(grade_arr[0]) && !grades.include?(grade_arr[1])
          prek_arr << TeacherSet::PRE_K_VAL
        elsif grades.include?(grade_arr[0]) && !grades.include?(grade_arr[1])
          return [grade_arr[0]]
        elsif !grades.include?(grade_arr[0]) && grades.include?(grade_arr[1])
          return [grade_arr[1]]
        else
          next
        end
      end
      prek_arr.uniq
    end


    # Grades = {Pre-K => -1, K => 0}
    def grade_val(val)
      return unless val.present?
      if val == 'K'
        TeacherSet::K_VAL
      elsif PREK_ARR.include?(val)
        TeacherSet::PRE_K_VAL
      else
        val.to_i
      end
    end
  # end private methods
end
