# frozen_string_literal: true

class IngestSierraCodeZcodeMatches2 < ActiveRecord::Migration[3.2]
  def up
    Rake::Task['ingest:overwrite_sierra_code_zcode_matches'].invoke('data/public/sierra_code_zcode_matches.csv')
  end
end
