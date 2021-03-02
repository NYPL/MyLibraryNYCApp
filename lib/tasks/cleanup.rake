# frozen_string_literal: true

namespace :cleanup do

  # Use it like this with one or more arguments: `rake cleanup:bib_records['book teacher_set']` or `rake cleanup:bib_records['book']`
  desc "cleanup books or teacher sets"
  task :bib_records, [:model_names] => :environment do |t, args|
    args.model_names.split(' ').each do |model_name|
      puts "Starting rake task to clean up #{model_name.humanize.pluralize}"
      ActiveRecord::Base.transaction do
        ids_with_duplicate_bibs = []
        model_name.camelize.constantize.all.each do |record|
          puts "#{model_name.humanize} ##{record.id}"
          # if bnumber is present and it is found in other records, add that ID to the array
          if record.bnumber.present? && model_name.camelize.constantize.where(bnumber: record.bnumber).count > 1
            puts "#{model_name.humanize} ##{record.id} has a duplicate bnumber (#{record.bnumber})"
            ids_with_duplicate_bibs << record.id
          end
        end
        puts "IDs of #{model_name.humanize.downcase.pluralize} with duplicate bnumbers: #{ids_with_duplicate_bibs}"
        puts "Duplicates count: #{ids_with_duplicate_bibs.size}"

        # delete the duplicate holds and teacher sets, and move their holds & books over to the teacher set that was most recently created
        ids_with_duplicate_bibs.each do |id_of_duplicate|
          bnumber = model_name.camelize.constantize.find(id_of_duplicate).bnumber
          duplicate_records = model_name.camelize.constantize.where(bnumber: bnumber).order('created_at DESC')
          first_duplicate_record = duplicate_records[0]
          duplicate_records.each do |duplicate_record|
            # skip the first duplicate so that we do not delete it or shift its holds and other associated models
            next if duplicate_record == first_duplicate_record

            if model_name == 'teacher_set'
              ['hold', 'subjects_teacher_set', 'teacher_set_book', 'teacher_set_note'].each do |associated_model_name|
                associated_records_for_associated_model = associated_model_name.camelize.constantize.where(teacher_set_id: duplicate_record.id)
                puts "There are #{associated_records_for_associated_model} associated #{associated_model_name}s to update."
                associated_records_for_associated_model.each do |associated_record_for_associated_model|
                  puts "Changing teacher_set_id for #{associated_model_name} ##{associated_record_for_associated_model.id}"
                  associated_record_for_associated_model.update(teacher_set_id: first_duplicate_record.id)
                end
              end
              # delete any duplicates in the join tables (this loop doesn't get triggered so there must be none)
              while associated_model_name.camelize.constantize.where(teacher_set_id: first_duplicate_record.id).count > 1
                associated_model_name.camelize.constantize.where(teacher_set_id: first_duplicate_record.id).first.destroy
              end
            elsif model_name == 'book'
              ['teacher_set_book'].each do |associated_model_name|
                associated_records_for_associated_model = associated_model_name.camelize.constantize.where(book_id: duplicate_record.id)
                "There are #{associated_records_for_associated_model} associated #{associated_model_name}s to update."
                associated_records_for_associated_model.each do |associated_record_for_associated_model|
                  puts "Changing book_id for #{associated_model_name} ##{associated_record_for_associated_model.id}"
                  associated_record_for_associated_model.update(book: first_duplicate_record)
                end
              end
              # delete any duplicates in the join tables (this loop doesn't get triggered so there must be none)
              while associated_model_name.camelize.constantize.where(teacher_set_id: first_duplicate_record.id).count > 1
                associated_model_name.camelize.constantize.where(teacher_set_id: first_duplicate_record.id).first.destroy
              end
            end
            puts "Deleting #{model_name.humanize.downcase} ##{duplicate_record.id}"
            duplicate_record.destroy
          end
        end
      end
    end
  end
end
