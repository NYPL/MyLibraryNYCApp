# frozen_string_literal: true

module TeacherSetsHelper
  # Supporting only below grades
  GRADES_1_12 = %w[1 2 3 4 5 6 7 8 9 10 11 12].freeze
  PREK_K_GRADES = ['PRE K', 'pre k', 'PRE-K', 'pre-k', 'Pre-K', 'Pre K', 'PreK', 'prek', 'K', 'k'].freeze
  PREK_ARR = ['PRE K', 'PRE-K', 'PREK'].freeze

  
  def var_field_data(marc_tag, merge = true)
    var_field(@req_body, marc_tag, merge)
  end


  def var_field(req_body, marc_tag, merge = true)
    if merge == true
      req_body['varFields'].detect { |hash| hash['marcTag'] == marc_tag }['subfields'].map { |x| x['content'] }.join(', ')
    else
      req_body['varFields'].detect { |hash| hash['marcTag'] == marc_tag }['subfields'].detect { |hash| hash['tag'] == 'a' }['content']
    end
  rescue StandardError
    nil
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
    grade_and_lexile_json = all_var_fields('521')
    return '' if grade_and_lexile_json.blank?

    grades_resp = get_grades(grade_and_lexile_json)
    grades_resp.each do |grade_or_lexile_json|
      begin
        if return_grade_or_lexile == 'lexile' && grade_or_lexile_json.include?('L')
          grade_or_lexile_json.delete('Lexile ').delete('L').split(' ')[0].split('-')
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
    rescue StandardError
      []
    end
  end


  def all_var_fields(marc_tag)
    @req_body['varFields'].select { |hash| hash['marcTag'] == marc_tag }.map { |x| x['subfields'][0]['content'] }
  rescue StandardError
    nil
  end


  def fixed_field(marc_tag)
    @req_body['fixedFields'][marc_tag]['display']
  rescue StandardError
    nil
  end


  # Parses out the items duedate, items code is '-' which determines if an item is available or not.
  # Calculates the total number of items in the list, the number of items that are
  # available to lend.
  def parse_items_available_and_total_count(response)
    available_count = 0
    total_count = 0
    response['data'].each do |item|
      total_count += 1 unless item['status']['code'].present? && %w(w m k u).include?(item['status']['code'])
      available_count += 1 if item['status']['code'].present? && item['status']['code'] == '-' && !item['status']['duedate'].present?
    end
    LogWrapper.log('INFO','message' => "TeacherSet available_count: #{available_count}, total_count: #{total_count}")
    
    [total_count, available_count]
  end
end
