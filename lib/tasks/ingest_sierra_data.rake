# frozen_string_literal: true

require 'net/http'
require 'uri'

require 'csv'

namespace :ingest_sierra_data do

  desc "Import sierra_codes and zcodes"
  task :import_sierra_codes_and_zcodes, [:file_name] => :environment do |_t, args|
    puts "starting import_sierra_codes_and_zcodes"
    csv_text = File.read(args.file_name)
    rows = CSV.parse(csv_text, headers: true)

    ActiveRecord::Base.transaction do
      rows.each_with_index do |row, _index|
        row_hash = row.to_hash
        sierra_code = row_hash['sierra_code'].strip
        zcode = row_hash['zcode'].strip
        puts "Creating sierra code #{sierra_code}"
        %w[sierra_code zcode].each do |column_header_name|
          if !row_hash.key?(column_header_name) || row_hash[column_header_name].blank?
            raise "The #{column_header_name} column is mislabeled or missing from the CSV."
          end
        end
        SierraCodeZcodeMatch.create!(sierra_code: sierra_code, zcode: zcode)
      end
    end
  end
end
