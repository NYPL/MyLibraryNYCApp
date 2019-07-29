def update_teacher_set_real_time_available_total_count
  start_time = Time.now
  failure_bib_ids = []
  not_found_ids = []
  success_bib_ids = []
  error_messages  = []
  TeacherSet.find_each do |ts|
    next if !ts.bnumber
    begin
      bib_id = '20025647'
      puts "Bib id: #{bib_id}"
      bibs_resp = ts.update_available_and_total_count(bib_id, 'sierra-nypl')
      if bibs_resp[:bibs_resp]['statusCode'] == 200
        success_bib_ids << bib_id
      else
        not_found_ids << bib_id
      end
    rescue => exception
      error_messages << "Error occured. #{exception.message}"
      LogWrapper.log('INFO','message' => exception.message)
      failure_bib_ids << bib_id
      sleep(5)
      next
    end
  end

  total_time = Time.now - start_time
  puts "TotalteachersetsCount: #{TeacherSet.count}", "UpdatedTeacheraSetCount: #{success_bib_ids.count.to_i + failure_bib_ids.count.to_i + not_found_ids.count.to_i}"
  puts "successIdsCount: #{success_bib_ids.count}", "failureIds: #{failure_bib_ids}", "failureIdsCount: #{failure_bib_ids.count}", "notFoundIds: #{not_found_ids}", "notFoundIdsCount: #{not_found_ids.count}", "totalTime: #{total_time}"
  puts "errorMessages: #{error_messages}"
end