# frozen_string_literal: true

module TeacherSetsHelper
  # Supporting only below grades
  GRADES_1_12 = %w[1 2 3 4 5 6 7 8 9 10 11 12].freeze
  PREK_K_GRADES = ['PRE K', 'pre k', 'PRE-K', 'pre-k', 'Pre-K', 'Pre K', 'PreK', 'prek', 'K', 'k'].freeze
  PREK_ARR = ['PRE K', 'PRE-K', 'PREK'].freeze

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

  # Supporting only below grades
  GRADES_1_12 = %w[1 2 3 4 5 6 7 8 9 10 11 12].freeze
  PREK_K_GRADES = ['PRE K', 'pre k', 'PRE-K', 'pre-k', 'Pre-K', 'Pre K', 'PreK', 'prek', 'K', 'k'].freeze
  PREK_ARR = ['PRE K', 'PRE-K', 'PREK'].freeze

  def var_field_data(marc_tag, merge = true)
    if merge == true
      @req_body['varFields'].detect { |hash| hash['marc_tag'] == marc_tag }['subfields'].map { |x| x['content'] }.join(', ')
    else
      @req_body['varFields'].detect { |hash| hash['marc_tag'] == marc_tag }['subfields'].detect { |hash| hash['tag'] == 'a' }['content']
    end
  rescue
    return nil
  end

  
  # "marc_tag": "521" {"tag": "a", "content": "11-12" } if field does not match with grades returns 'Pre-K +'.
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
      
      grade_arr = grade.delete('.').split('-')
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
          return grade_or_lexile_json.delete('Lexile ').delete('L').split(' ')[0].split('-')
        elsif return_grade_or_lexile == 'grade' && !grade_or_lexile_json.include?('L')
          if grade_or_lexile_json.upcase.include?('PRE')
            # Prek values: ['PRE K', 'pre k', 'PRE-K', 'pre-k', 'Pre-K', 'Pre K', 'PreK', 'prek'] - supporting these values only
            PREK_ARR.each do |val|
              grades = grade_or_lexile_json.upcase.delete('.').split("#{val}-")
              return [TeacherSet::PRE_K_VAL, grade_val(grades[1])] if grades.length > 1
            end
          elsif grade_or_lexile_json.upcase.include?('K')
            # K values: [K, k] - supporting these values only
            grade = grade_or_lexile_json.upcase.delete('.').split('K-')[1]
            return [TeacherSet::K_VAL, grade_val(grade)]
          else
            return grade_or_lexile_json.delete('.').split('-')
          end
        elsif grade_or_lexile_json.upcase.include?('K')
          # K values: [K, k] - supporting these values only
          grade = grade_or_lexile_json.upcase.delete('.').split('K-')[1]
          return [TeacherSet::K_VAL, grade_val(grade)]
        else
          return grade_or_lexile_json.delete('.').split('-')
        end
      end
    rescue
      []
    end
  end


  def all_var_fields(marc_tag)
    @req_body['varFields'].select { |hash| hash['marc_tag'] == marc_tag }.map { |x| x['subfields'][0]['content'] }
  rescue
    return nil
  end


  def fixed_field(marc_tag)
    @req_body['fixedFields'][marc_tag]['display']
  rescue
    return nil
  end
end
