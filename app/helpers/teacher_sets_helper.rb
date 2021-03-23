# frozen_string_literal: true

module TeacherSetsHelper

  # Supporting only below grades
  GRADES_1_12 = %w[1 2 3 4 5 6 7 8 9 10 11 12].freeze
  PREK_K_GRADES = ['PRE K', 'pre k', 'PRE-K', 'pre-k', 'Pre-K', 'Pre K', 'PreK', 'prek', 'K', 'k'].freeze
  PREK_ARR = ['PRE K', 'PRE-K', 'PREK'].freeze

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
