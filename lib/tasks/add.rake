# frozen_string_literal: true

# ******* PLEASE READ ***********
# This rake task is used for the purpose of migrating the 
# production database on heroku to the production database on AWS RDS.
# This rake task assumes your database is already created.
# Commented out due to never being used again. 

# desc "Add prod data to #{ENV['RAILS_ENV']} db"
# task :add_data, [] => :environment do |t, args|

# 	sh 'dropdb mln_development --if-exists'
# 	sh 'heroku pg:pull DATABASE mln_development -a mylibrarynyc'
# 	sh 'psql mln_development -c "alter table teacher_sets drop column test_column"'
# 	sh 'pg_dump mln_development -f db/seed-data.sql --data-only --exclude-table="schema_migrations" --inserts --column-inserts'
# 	sh "psql #{ENV['DATABASE_URL']} -c 'drop schema public cascade'"
# 	sh "psql #{ENV['DATABASE_URL']} -c 'create schema public'"

# 	File.rename(Dir.pwd + '/db/migrate/20180822154247_import_all_nyc_schools.rb', Dir.pwd + '/db/migrate/.20180822154247_import_all_nyc_schools.rb')
# 	File.rename(Dir.pwd + '/db/migrate/20180821150047_cleanup_school_codes.rb', Dir.pwd + '/db/migrate/.20180821150047_cleanup_school_codes.rb')

# 	sh 'rake db:migrate'
# 	sh 'rake db:seed'

# 	File.rename(Dir.pwd + '/db/migrate/.20180822154247_import_all_nyc_schools.rb', Dir.pwd + '/db/migrate/20180822154247_import_all_nyc_schools.rb')
# 	File.rename(Dir.pwd + '/db/migrate/.20180821150047_cleanup_school_codes.rb', Dir.pwd + '/db/migrate/20180821150047_cleanup_school_codes.rb')

# 	sh 'rake db:migrate'

# end 
