
namespace :tests do

  # Fetch latest data from biblio
  desc "Run integration and unit tests"
  task :all => :environment do
  	system("ruby -Itest test/integration/user_flow_test.rb")
  	system("ruby -Itest test/unit/user_test.rb")
  end 

  desc "Run integration tests"
  task :integration => :environment do 
    system("ruby -Itest test/integration/user_flow_test.rb")
  end 

  desc "Run unit tests"
  task :unit => :environment do 
  	system("ruby -Itest test/unit/user_test.rb")
  end 

end