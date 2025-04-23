# frozen_string_literal: true

require "net/http"
require "uri"
require "csv"

namespace :ingest_sierra_data do
  desc "Import sierra_codes and zcodes"
  task :import_sierra_codes_and_zcodes, [:file_name] => :environment do |_t, args|
    puts "starting import_sierra_codes_and_zcodes"
    csv_text = File.read(args.file_name)
    rows = CSV.parse(csv_text, headers: true)

    ActiveRecord::Base.transaction do
      rows.each_with_index do |row, _index|
        row_hash = row.to_hash
        sierra_code = row_hash["sierra_code"].strip
        zcode = row_hash["zcode"].strip
        puts "Creating sierra code #{sierra_code}"
        sierra_data = %w[sierra_code zcode]
        sierra_data.each do |column_header_name|
          if !row_hash.key?(column_header_name) || row_hash[column_header_name].blank?
            raise "The #{column_header_name} column is mislabeled or missing from the CSV."
          end
        end
        SierraCodeZcodeMatch.update!(sierra_code: sierra_code, zcode: zcode)
      end
    end
  end

  desc "Update school zcodes"
  task :update_sierra_zcodes, [:file_name] => :environment do |_t, args|
    puts "starting update_school_zcodes"
    csv_text = File.read(args.file_name)
    rows = CSV.parse(csv_text, headers: true)

    ActiveRecord::Base.transaction do
      rows.each_with_index do |row, _index|
        row_hash = row.to_hash
        sierra_code = row_hash["sierra_code"].strip
        zcode = row_hash["zcode"].strip
        zcode_match = SierraCodeZcodeMatch.find_by_sierra_code("1980")
        puts "Updating zcode #{sierra_code}"
        sierra_data = %w[sierra_code zcode]
        sierra_data.each do |column_header_name|
          if !row_hash.key?(column_header_name) || row_hash[column_header_name].blank?
            raise "The #{column_header_name} column is mislabeled or missing from the CSV."
          end
        end
        if zcode_match.present?
          school = School.find_by_code(zcode_match.zcode)
          school.update!(code: zcode) if school.present?
          zcode_match.update!(zcode: zcode)
        end
      end
    end
  end
end
