# frozen_string_literal: true

class IngestSierraCodeZcodeMatches < ActiveRecord::Migration[4.2]
  def up
    Rake::Task['ingest:overwrite_sierra_code_zcode_matches'].invoke('data/public/sierra_code_zcode_matches.csv')
  end
end
