namespace :db do
  desc "Setup the database if it doesn't exist"
  task set_up_for_local: :environment do
    env = ENV['RAILS_ENV'] || 'development'

    if ActiveRecord::Base.connection.database_exists?
      puts "#{env.capitalize} database already exists"
    else
      puts "Setting up #{env} database..."
      Rake::Task["db:create"].invoke
      Rake::Task["db:schema:load"].invoke
      Rake::Task["db:seed"].invoke if env == 'development'
    end
  end
end

