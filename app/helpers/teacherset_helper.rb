module TeachersetHelper

  def teacher_set_info(ts)
    created_at = ts.created_at.present? ? ts.created_at.strftime("%Y-%m-%dT%H:%M:%S%z") : nil
    updated_at = ts.updated_at.present? ? ts.updated_at.strftime("%Y-%m-%dT%H:%M:%S%z") : nil
    availability = ts.availability.present? ? ts.availability.downcase : nil
    {title: ts.title, description: ts.description, contents: ts.contents, 
      id: ts.id.to_i, details_url: ts.details_url, grade_end: ts.grade_end, 
      grade_begin: ts.grade_begin, availability: availability, total_copies: ts.total_copies,
      call_number: ts.call_number, language: ts.language, physical_description: ts.physical_description,
      primary_language: ts.primary_language, created_at: created_at, updated_at: updated_at,
      available_copies: ts.available_copies, bnumber: ts.bnumber, set_type: ts.set_type }
  end

  def create_or_update_teacherset_document_in_es(ts_object)
    body = teacher_set_info(ts_object)
    begin
      ElasticSearch.new.update(body[:id], body)
      LogWrapper.log('DEBUG', {'message' => "Successfullly updated elastic search doc. Teacher set id #{body[:id]}", 
                               'method' => 'app/helpers/create_or_update_teacherset_document_in_es'})
    rescue Elasticsearch::Transport::Transport::Errors::NotFound => e
      ElasticSearch.new.create_document(body[:id], body)
      LogWrapper.log('DEBUG', {'message' => "Successfullly created elastic search doc. Teacher set id #{body[:id]}", 
                               'method' => 'app/helpers/create_or_update_teacherset_document_in_es'})
    end
  end

  def delete_teacheset_record_from_es(id)
    resp = ElasticSearch.new.delete_document_by_id(id)
    if resp["found"] && resp["result"] == "deleted"
      LogWrapper.log('DEBUG', {'message' => "Successfullly deleted elastic search doc. Teacher set id #{id}", 
                               'method' => 'app/helpers/delete_teacheset_record_from_es'})
    end
  end
end
