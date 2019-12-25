# frozen_string_literal: true

class IngestSierraCodeZcodeMatches < ActiveRecord::Migration[4.2]
  # Note: Commented out 2019-12-25 to speed up travis builds.
  # def up
  #   Rake::Task['ingest:overwrite_sierra_code_zcode_matches'].invoke('data/public/sierra_code_zcode_matches.csv')
  # end
end
