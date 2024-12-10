# frozen_string_literal: true

module TeacherSetsEsHelper
  # Make teacherset object from elastic search document
  def teacher_sets_from_elastic_search_doc(es_doc)
    arr = []
    if es_doc[:hits].present?
      es_doc[:hits].each do |ts|
        next if ts["_source"]['mappings'].present?

        teacher_set = TeacherSet.new
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
end
