require 'test_helper'
require 'rake'

class IngestRakeTaskTest < ActiveSupport::TestCase

  setup do
    MyLibraryNYC::Application.load_tasks
  end

  test 'rake ingest:import_all_nyc_schools imports a school successfully' do
    Rake::Task["ingest:import_all_nyc_schools"].invoke('data/public/for_unit_test_2016_-_2017_School_Locations.csv')
    zcode = 'zM015'
    school = School.find_by_code(zcode)
    assert school.state == 'NY'
    assert school.address_line_2 == 'MANHATTAN, NY 10009'
    assert school.postal_code == '10009'
    assert school.phone_number == '212-228-8730'
    assert school.borough == 'MANHATTAN'
  end

  test 'rake ingest:overwrite_sierra_code_zcode_matches imports a join successfully' do
    assert SierraCodeZcodeMatch.count == 0
    Rake::Task["ingest:overwrite_sierra_code_zcode_matches"].invoke('data/public/for_unit_test_sierra_code_zcode_matches.csv')
    assert SierraCodeZcodeMatch.count == 1
  end
end
