class UpdateAllMlnBibIds < ActiveRecord::Migration[5.0]
  def up
    failed_bib_ids = []
    count = 0;

    TeacherSet.find_each do |ts|
      count += 1
      next unless ts.bnumber.present?
      begin
        bib_id = ts.bnumber.delete "b"
        bib_response = ts.send_request_to_bibs_microservice(bib_id)

        # If Bib response is other than 200 skip to next bib
        next if bib_response["statusCode"] != 200
        params = {_json: bib_response['data']}
        Api::V01::BibsController.new.update_mln_bib_ids(params)
      rescue Exception => e
        failed_bib_ids << [bib_id, error_message: e.message]
        next
      end
      [failed_ids: failed_bib_ids, total_count: count]
    end
  end
end
