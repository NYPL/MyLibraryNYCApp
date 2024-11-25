namespace :seeds do
  desc "Seed Teacher Sets in Elasticsearch"

  task teacher_sets: :environment do
    failed = []
    TeacherSet.find_each(batch_size: 1) do |ts|
      created_at = ts.created_at.present? ? ts.created_at.strftime("%Y-%m-%dT%H:%M:%S%z") : nil
      updated_at = ts.updated_at.present? ? ts.updated_at.strftime("%Y-%m-%dT%H:%M:%S%z") : nil
      availability = ts.availability.present? ? ts.availability.downcase : nil

      begin
        subjects_arr = []

        if ts.subjects.present?
          ts.subjects.uniq.each do |subject|
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

        body = {
          title: ts.title,
          description: ts.description,
          contents: ts.contents,
          id: ts.id.to_i,
          details_url: ts.details_url,
          grade_end: ts.grade_end,
          grade_begin: ts.grade_begin,
          availability: availability,
          total_copies: ts.total_copies,
          call_number: ts.call_number,
          language: ts.language,
          physical_description: ts.physical_description,
          primary_language: ts.primary_language,
          created_at: created_at,
          updated_at: updated_at,
          available_copies: ts.available_copies,
          bnumber: ts.bnumber,
          set_type: ts.set_type,
          area_of_study: ts.area_of_study,
          subjects: subjects_arr
        }

        ElasticSearch.new.create_document(ts.id, body)
        puts "updating elastic search"
      rescue Elasticsearch::Transport::Transport::Errors::Conflict => e
        puts "Error in elastic search: #{e.inspect}"
        failed << ts.id
      end
    end
    puts "Teacher sets with ids #{failed} not created" unless failed.empty?
  end
end
