# frozen_string_literal: true

require 'active_support/concern'

module TeacherSetConcern
  extend ActiveSupport::Concern
  # Make request input body to create teacherset document in elastic search.
  # Input param ts_obj eg: <TeacherSet:0x00007fd79383a640 id: 350, title: "Step",call_number: "Teacher",
  # description: "Book", details_url: "http://catalog.nypl.org/record=b21378444~S1","updated-7571-Step up to the plate, Maria Singh">
  # Expected response from this method {:title=>"Step Up", :description=> "Book", :contents=>"Step Up", :id=>350}

  def teacher_set_info(ts_obj)
    created_at = ts_obj.created_at.present? ? ts_obj.created_at.strftime("%Y-%m-%dT%H:%M:%S%z") : nil
    updated_at = ts_obj.updated_at.present? ? ts_obj.updated_at.strftime("%Y-%m-%dT%H:%M:%S%z") : nil
    availability = ts_obj.availability.present? ? ts_obj.availability.downcase : nil

    subjects_arr = []
    # Teacherset have has_many relationship with subjects
    # Get teacherset subjects from db than update in elastic search.
    if ts_obj.subjects.present?
      ts_obj.subjects.distinct.each do |subject|
        subjects_hash = {}
        s_created_at = subject.created_at.present? ? subject.created_at.strftime("%Y-%m-%dT%H:%M:%S%z") : nil
        s_updated_at = subject.updated_at.present? ? subject.updated_at.strftime("%Y-%m-%dT%H:%M:%S%z") : nil
        subjects_hash[:id] = subject.id
        subjects_hash[:title] = subject.title
        subjects_hash[:created_at] = s_created_at
        subjects_hash[:updated_at] = s_updated_at
        subjects_arr << subjects_hash
      end
    end
    {title: ts_obj.title, description: ts_obj.description, contents: ts_obj.contents, 
      id: ts_obj.id.to_i, details_url: ts_obj.details_url, grade_end: ts_obj.grade_end, 
      grade_begin: ts_obj.grade_begin, availability: availability, total_copies: ts_obj.total_copies,
      call_number: ts_obj.call_number, language: ts_obj.language, physical_description: ts_obj.physical_description,
      primary_language: ts_obj.primary_language, created_at: created_at, updated_at: updated_at,
      available_copies: ts_obj.available_copies, bnumber: ts_obj.bnumber, set_type: ts_obj.set_type,
      area_of_study: ts_obj.area_of_study, subjects: subjects_arr }
  end


  def update_teacher_set_attribuites(teacher_set, ts_items_info)
    teacher_set.update(
      title: title,
      call_number: var_field_data('091'),
      description: var_field_data('520'),
      edition: var_field_data('250'),
      isbn: var_field_data('020'),
      primary_language: fixed_field('24'),
      publisher: var_field_data('260'),
      contents: var_field_data('505'),
      area_of_study: var_field_data('690', false),
      physical_description: physical_description,
      details_url: "http://catalog.nypl.org/record=b#{teacher_set.id}~S1",
      # If Grade value is Pre-K saves as -1 and Grade value is 'K' saves as '0' in TeacherSet table.
      grade_begin: grade_or_lexile_array('grade')[0] || '',
      grade_end: grade_or_lexile_array('grade')[1] || '',
      lexile_begin: grade_or_lexile_array('lexile')[0] || '', # NOTE: lexile functionality has been taken off
      lexile_end: grade_or_lexile_array('lexile')[1] || '', # NOTE: lexile functionality has been taken off
      available_copies: ts_items_info[:available_count],
      total_copies: ts_items_info[:total_count],
      availability: ts_items_info[:availability_string]
    )
    teacher_set
  end


  # Save teacher-set set_type value
  def update_teacher_set_set_type_value(set_type_val)
    begin
      set_type = update_set_type(set_type_val)
      LogWrapper.log('INFO', {'message' => "Teacher set set_type value: #{set_type} saved in DB", 
                              'method' => 'teacher_set.update_teacher_set_set_type_value'})
    rescue StandardError => e
      raise MlnException::DBException.new(MlnResponse::TEACHERSET_SETTYPE_ERROR[:code],
            MlnResponse::TEACHERSET_SETTYPE_ERROR[:msg])
    end
  end


  # Create or update teacherset document in elastic search.
  def create_or_update_teacherset_document_in_es(ts_object)
    body = teacher_set_info(ts_object)
    begin
      # If teacherset document is found in elastic search than update document in ES.
      ElasticSearch.new.update_document_by_id(body[:id], body)
      LogWrapper.log('DEBUG', {'message' => "Successfullly updated elastic search doc. Teacher set id #{body[:id]}", 
                               'method' => 'app/helpers/create_or_update_teacherset_document_in_es'})
    rescue Elasticsearch::Transport::Transport::Errors::NotFound => e
      # If teacherset document not found in elastic search than create document in ES.
      resp = ElasticSearch.new.create_document(body[:id], body)
      if resp['result'] == "created"
        LogWrapper.log('DEBUG', {'message' => "Successfullly created elastic search doc. Teacher set id #{body[:id]}", 
                                 'method' => 'app/helpers/create_or_update_teacherset_document_in_es'})
      else
        LogWrapper.log('ERROR', {'message' => "Elastic search document not created/updated. Error: #{e.message}. Teacher set id #{body[:id]}", 
                                 'method' => 'app/helpers/create_or_update_teacherset_document_in_es'})
      end
    rescue StandardError => e
      raise MlnException::ElasticsearchException.new(MlnResponse::ELASTIC_SEARCH_STANDARD_EXCEPTION[:code],
            MlnResponse::ELASTIC_SEARCH_STANDARD_EXCEPTION[:msg])
      LogWrapper.log('ERROR', {'message' => "Error occured while updating elastic search doc. Teacher set id #{body[:id]}. Error: #{e.message}",
                               'method' => 'app/helpers/create_or_update_teacherset_document_in_es'})
    end
  end

  
  # When Delete request comes from sierra, than delete teacher set document in elastic search.
  def delete_teacherset_record_from_es(id)
    begin
      resp = ElasticSearch.new.delete_document_by_id(id)
      return unless resp["result"] == "deleted"
      
      LogWrapper.log('DEBUG', {'message' => "Successfullly deleted elastic search doc. Teacher set id #{id}", 
                               'method' => 'app/helpers/delete_teacherset_record_from_es'})
    rescue StandardError => e
      raise MlnException::ElasticsearchException.new(MlnResponse::ELASTIC_SEARCH_STANDARD_EXCEPTION[:code],
            MlnResponse::ELASTIC_SEARCH_STANDARD_EXCEPTION[:msg])
      LogWrapper.log('ERROR', {'message' => "Error occured while deleting elastic search doc. Teacher set id #{body[:id]}. Error: #{e.message}",
                               'method' => 'app/helpers/create_or_update_teacherset_document_in_es'})

    end
  end

  
  # Make teacherset object from elastic search json
  def create_ts_object_from_es_json(json)
    arr = []
    if json[:hits].present? && json[:hits].present?
      json[:hits].each do |ts|
        teacher_set = TeacherSet.new
        next if ts["_source"]['mappings'].present?

        teacher_set.title = ts["_source"]['title']
        teacher_set.description = ts["_source"]['description']
        teacher_set.contents = ts["_source"]['contents']
        teacher_set.grade_begin = ts["_source"]['grade_begin']
        teacher_set.grade_end = ts["_source"]['grade_end']
        teacher_set.language = ts["_source"]['language']
        teacher_set.id = ts["_source"]['id']
        teacher_set.details_url = ts["_source"]['details_url']
        teacher_set.availability = ts["_source"]['availability']
        teacher_set.total_copies = ts["_source"]['total_copies']
        teacher_set.call_number = ts["_source"]['call_number']
        teacher_set.language = ts["_source"]['language']
        teacher_set.physical_description = ts["_source"]['physical_description']
        teacher_set.primary_language = ts["_source"]['primary_language']
        teacher_set.created_at = ts["_source"]['created_at']
        teacher_set.updated_at = ts["_source"]['updated_at']
        teacher_set.available_copies = ts["_source"]['available_copies']
        teacher_set.bnumber = ts["_source"]['bnumber']
        teacher_set.set_type = ts["_source"]['set_type']
        arr << teacher_set 
      end
    end
    arr
  end


  def var_field_data(marcTag, merge = true)
    begin
      if merge == true
        @req_body['varFields'].detect{ |hash| hash['marcTag'] == marcTag }['subfields'].map{ |x| x['content']}.join(', ')
      else
        @req_body['varFields'].detect{ |hash| hash['marcTag'] == marcTag }['subfields'].detect{ |hash| hash['tag'] == 'a' }['content']
      end
    rescue
      return nil
    end
  end


  # Supporting only below grades
  GRADES_1_12 = %w[1 2 3 4 5 6 7 8 9 10 11 12].freeze
  PREK_K_GRADES = ['PRE K', 'pre k', 'PRE-K', 'pre-k', 'Pre-K', 'Pre K', 'PreK', 'prek', 'K', 'k'].freeze
  PREK_ARR = ['PRE K', 'PRE-K', 'PREK'].freeze
  # "marcTag": "521" {"tag": "a", "content": "11-12" } if field does not match with grades returns 'Pre-K +'.
  # eg: ["dd", "11-444", "Z", "1130L"] -  only 11 is matched with supporting grades. It returns 11 +
  # eg: ["9", "11-444", "Z", "1130L"] -  9 and 11 matched with supporting grades. It returns 9 +
  # eg: ["9", "114-4", "Z", "1130L"] -  4 matched with supporting grades. It returns 4 +
  def get_grades(grade_and_lexile_json)
    grades = GRADES_1_12 + PREK_K_GRADES
    grades_arr = []
    prek_arr = []
    grade_and_lexile_json.each do |gd|
      grade = gd.strip
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


  def all_var_fields(marcTag, tag)
    begin
      @req_body['varFields'].select{ |hash| hash['marcTag'] == marcTag }.map{|x| x['subfields'][0]['content']}
    rescue
      return nil
    end
  end


  def fixed_field(marcTag)
    begin
      @req_body['fixedFields'][marcTag]['display']
    rescue
      return nil
    end
  end
end
