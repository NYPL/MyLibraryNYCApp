#require "bundler/gem_tasks"
require "rake/testtask"
Rake::Task['test:run'].clear

namespace :combined_tests do

  desc "Run tests"
  #task :combined_tests, []  => :environment do |t, args|
  Rake::TestTask.new do |t|
    t.libs << "lib"
    t.libs << "test"

    # if we let rake run all tests, then some of the tests fail due to age.
    # t.test_files = FileList['test/**/*.rb']

    # for now, specify the test file to run.
    # this will also help automate for travis
    t.test_files = Rake::FileList['test/unit/teacher_set_test.rb',
      'test/unit/ingest_rake_task_test.rb',
      'test/integration/user_flow_test.rb',
      'test/functional/exceptions_controller_test.rb',
      'test/functional/api/v01/bibs_controller_test.rb',
      'test/unit/user_test.rb', 'test/unit/book_test.rb'
    ].shuffle
    # t.test_files = Rake::FileList['test/unit/user_test.rb', "test/unit/book_test.rb",
    #  'test/unit/teacher_set_test.rb', 'test/unit/ingest_rake_task_test.rb',
    #  'test/integration/user_flow_test.rb', 'test/functional/exceptions_controller_test.rb',
    #  'test/functional/api/v01/bibs_controller_test.rb'].shuffle()

    t.verbose = false
  # end
  end


  # set the test task as default for safety
  # task default: :test2
end
