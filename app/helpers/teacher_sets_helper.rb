# frozen_string_literal: true

module TeacherSetsHelper
  # Request input body to create teacherset document in elastic search.
  def teacher_set_info(ts_obj)
    created_at = ts_obj.created_at.present? ? ts_obj.created_at.strftime("%Y-%m-%dT%H:%M:%S%z") : nil
    updated_at = ts_obj.updated_at.present? ? ts_obj.updated_at.strftime("%Y-%m-%dT%H:%M:%S%z") : nil
    availability = ts_obj.availability.present? ? ts_obj.availability.downcase : nil

    subjects_arr = []
    # Teacherset have has_many relationship with subjects
    # Get teacherset subjects from db than update in elastic search.
    if ts_obj.subjects.present?
      ts_obj.subjects.uniq.each do |subject|
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
      available_copies: ts_obj.available_copies, bnumber: ts_obj.bnumber, set_type: ts_obj.set_type }
  end

  
  # Create or update teacherset document in elastic search.  
  def create_or_update_teacherset_document_in_es(ts_object)
    body = teacher_set_info(ts_object)
    begin
      # If teacherset document is found in elastic search than update document in ES.
      ElasticSearch.new.update(body[:id], body)
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
      LogWrapper.log('ERROR', {'message' => "Error occured while updating elastic search doc. Teacher set id #{body[:id]}. Error: #{e.message}",
                               'method' => 'app/helpers/create_or_update_teacherset_document_in_es'})
    end
  end

  
  # When Delete request comes from sierra, than delete teacher set documnet in elastic search.
  def delete_teacheset_record_from_es(id)
    resp = ElasticSearch.new.delete_document_by_id(id)
    return unless resp["found"] && resp["result"] == "deleted"

    LogWrapper.log('DEBUG', {'message' => "Successfullly deleted elastic search doc. Teacher set id #{id}", 
                               'method' => 'app/helpers/delete_teacheset_record_from_es'})
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
end
