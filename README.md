MyLibraryNYC
============

My Library NYC Mobile Pilot

For a description, check the [wiki](https://confluence.nypl.org/display/WT/My+Library+NYC).


Local Development
=================

To build and run the app locally:
1. `docker-compose build`
2. `docker-compose up`

The app will be available at `http://localhost:3000`.


Data
====

To create and seed the database:

1. Load schema and data (from within the webapp container):

```
bundle exec rake db:create db:migrate db:seed
```

To dump data to seed-data dump file (i.e. for use by other devs):

```
pg_dump -U postgres mylibrarynyc -f db/seed-data.sql --data-only --exclude-table="schema_migrations|holds|users" --inserts --column-inserts
```

To Import New NYC Schools:

Assuming your CSV is public data, upload it under root/data/public.  Here are the required column headers with example data from the August '18 CSV:
```
'ATS SYSTEM CODE' (ie '01M019')
'LOCATION_NAME' (ie 'P.S. 9999')
'PRIMARY_ADDRESS_LINE_1' (ie '130 EAST  10 STREET')
'STATE_CODE' (ie NY)
'Location 1' (ie 'MANHATTAN, NY 10009 (40.722075, -73.978747)"' on two lines)
'PRINCIPAL_PHONE_NUMBER' (ie '212-000-0000')
```

Run this command from the local webapp container or in the ECS webapp container in AWS (replace the filename in the command): `rake ingest:import_all_nyc_schools['data/public/2016_-_2017_School_Locations.csv']`

If the school is not found by zcode, the rake task will create a new record.  If the school is found by zcode, it will overwrite school's name, address_line_1, state, address_line_2, borough, postal_code, and phone_number with the data in the CSV.


Travis-CI
==================

Important to note, MyLibraryNYC is integrated with Travis-CI.

This means the following:

When a developer, commits a change or merges a branch into the qa or production branch, it will trigger a deployment with travis. If the build is is successful, Travis will deploy the build to the corresponding environment in AWS/ECS.


Testing
========================

First, set up a test database:
RAILS_ENV=test bundle exec rake db:drop db:create db:schema:load

For the unit tests and integration tests, please run the following command inside a webapp container while in the root directory.

```
RAILS_ENV=test bundle exec rails test
```


Show Maintenance Banner Configuration
========================
```ENV['SHOW_MAINTENANCE_BANNER'] = 'TRUE'```
The parameter should be set to the string `TRUE` to turn on the banner, which is coded in app/views/layouts/angular.html.erb and app/views/layouts/application.html.erb.
```ENV['MAINTENANCE_BANNER_TEXT'] = 'Maintenance banner text'```
It should be set to the string message that is to appear on the maintenance banner.  It will only appear if the `SHOW_MAINTENANCE_BANNER` parameter above is set to `TRUE`.


Rubocop
========================
```
Running rubocop with no arguments will check all Ruby source files in the current directory:

bundle exec rubocop

Alternatively you can pass rubocop a list of files and directories to check:

bundle exec rubocop folder_name/file_name.rb
```


Emails
========================
```
Emailing notifications out of MyLibraryNYC is done through the AWS Simple Email Service.  We turn emails off on the development and local servers by setting

config.action_mailer.perform_deliveries = false
in config/environments/development.rb

So if you want to test mailing locally, turn the perform_deliveries back on.
```

Setting Up ElasticSearch locally
=================================

```
The MylibraryNyc project uses elastic-search-6.8.

Make sure the elasticsearch container is running. Then, enter into a webapp container.

Do 'sh script/elastic_search/create_es_index_mappings.sh'

If that doesn't work, you can try 'sh script.elastic_search/delete_es_mappings.sh' first.

Enter the local elasticsearch URL (currently http://elasticsearch:9200)

Run the code below in a rails console to update teacherset doc data in the elasticsearch cluster.

TeacherSet.find_each do |ts|
  arr = []
  created_at = ts.created_at.present? ? ts.created_at.strftime("%Y-%m-%dT%H:%M:%S%z") : nil
  updated_at = ts.updated_at.present? ? ts.updated_at.strftime("%Y-%m-%dT%H:%M:%S%z") : nil
  availability = ts.availability.present? ? ts.availability.downcase : nil
  begin
    subjects_arr = []
    if ts.subjects.present?
      ts.subjects.uniq.each do |subject|
        subjects_hash = {}
        s_created_at = subject.created_at.present? ? subject.created_at.strftime("%Y-%m-%dT%H:%M:%S%z") : nil
        s_updated_at = subject.updated_at.present? ? subject.updated_at.strftime("%Y-%m-%dT%H:%M:%S%z") : nil
        subjects_hash[:id] = subject.id
        subjects_hash[:title] = subject.title
        subjects_hash[:created_at] = s_created_at
        subjects_hash[:updated_at] = s_updated_at
        subjects_arr << subjects_hash
      end
    end
    body = {title: ts.title, description: ts.description, contents: ts.contents,
      id: ts.id.to_i, details_url: ts.details_url, grade_end: ts.grade_end,
      grade_begin: ts.grade_begin, availability: availability, total_copies: ts.total_copies,
      call_number: ts.call_number, language: ts.language, physical_description: ts.physical_description,
      primary_language: ts.primary_language, created_at: created_at, updated_at: updated_at,
      available_copies: ts.available_copies, bnumber: ts.bnumber, set_type: ts.set_type,
      area_of_study: ts.area_of_study, subjects: subjects_arr}
    ElasticSearch.new.create_document(ts.id, body)
    puts "updating elastic search"
  rescue Elasticsearch::Transport::Transport::Errors::Conflict => e
     puts "Error in elastic search"
    arr << ts.id
  end
  arr
end

```


Commands to copy database from one environmentt to another
=========================================================

```
Dump the database you're interested in.
'pg_dump' dumps a database as a text file or to other formats.


Run database dump commands:
Command: pg_dump --host={host_name} --username mylibrarynyc --file file_name.out {database_name}

Before restoring the database
1) It is recommended to have a backup by taking a snapshot of the existing database.
2) Stop all services using the database.

Run the commands below in a terminal or at the command line.

psql postgres;
DROP database {database_name};
or
DROP SCHEMA public CASCADE;

CREATE SCHEMA public;

Run restore database commands:
'pg_restore' is a utility for restoring a PostgreSQL database from an archive created by pg_dump in one of the non-plain-text formats.

Command: pg_restore --verbose --host {host_name} --username {user_name} --dbname {database_name} file_name.out

Example1: pg_restore --verbose --host localhost --dbname qa_new_name1 qa-new_name1.text

Example2: psql --host localhost --dbname latest_qa1 -f qa-new_name.out
```
