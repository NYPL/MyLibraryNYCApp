MyLibraryNYC
============

My Library NYC Mobile Pilot

For a description, check the [wiki](https://confluence.nypl.org/display/WT/My+Library+NYC).


Data
====

To create and seed the database:

1. Create postgres db and create `config/database.yml` with your creds. Don't add this file to git.

2. Load schema and data:

```
rake db:create
rake db:migrate
rake db:seed
```

To dump data to seed-data dump file (i.e. for use by other devs):

```
pg_dump -U_postgres mylibrarynyc -f db/seed-data.sql --data-only --exclude-table="schema_migrations|holds|users" --inserts --column-inserts
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

Run this command from the console locally and on AWS (replace the filename in the command): `rake ingest:import_all_nyc_schools['data/public/2016_-_2017_School_Locations.csv']`

If the school is not found by zcode, the rake task will create a new record.  If the school is found by zcode, it will overwrite school's name, address_line_1, state, address_line_2, borough, postal_code, and phone_number with the data in the CSV.


Development Server
==================
The development server currently lives at http://my-library-nyc-app-development.us-east-1.elasticbeanstalk.com/.

This server uses the 'development' branch from this repository, to share current features that are being developed.

Setting up the development server (and how to set up other servers, e.g. a staging server):

1. Create app in AWS Elastic Beanstalk. To do so, run "eb init" in the root  directory of your repo. This will prompt a list of questions you need to answer.(if "eb" command is not installed, run "pip install awsebcli")

2. Next run the following command. Please add the appropriate substitutions where you see [key]. The purpose of this command is to the deploy the environment on Elastic Beanstalk. You will be prompted a list of questions you need to answer.

```
eb create [environment_name] --single --instance_profile cloudwatchable-beanstalk --instance_type t2.micro --cname [cname_name] --vpc.ec2subnets subnet-9ef736b3 --vpc.id vpc-dbc4f7bc --profile nypl-sandbox --keyname dgdvteam --tags Project=MyLibraryNyc,Environment=development
```

Make sure the following environment variables are set in your EB environment configuration:
BUNDLE_WITHOUT=test:development
LOGGING=debug
RACK_ENV=development
RAILS_ENV=development
RAILS_SKIP_ASSET_COMPILATION=false
RAILS_SKIP_MIGRATIONS=false


How to deploy to this server:

1. Make sure you deploy the development branch.

```
eb deploy [branch_name]
```

Travis-CI
==================

Important to note, MyLibraryNYC on the current development is integrated with Travis-CI.

It means the following:

When a developer, commits a change on the development branch or merges another branch on to development, it will trigger a deployment with travis. If the build is is successful, Travis will deploy the development code to our development server on AWS Elastic Beanstalk.

More documentation can be found here: [travis-confluence-page](https://confluence.nypl.org/display/WT/Travis-CI+Integration+with+MyLibraryNYC+to+AWS+Elastic+Beanstalk)


Environment Variables
========================

Once the application is deployed on AWS Elastic Beanstalk, you need to set environment variables within the environment.

Specifically, setting the `ENV['DATABASE_URL']` is critical in order for the application to function properly and also to not throw you any errors.

In order to do so, follow the current steps.

1. In AWS, go to the Elastic Beanstalk section.
2. Find your application/environment.
3. Click on Configuration and then Software.
4. Scroll down to Environment properties, and please set your variables accordingly.

Most of the environment variables get set in the .ebextensions files.  The .ebextensions files get executed in alphabetic order,
e.g. "00_environment.config" will execute before "01_cloudwatch_agent_config.config".

Most .ebextensions settings will override whatever you set in the console.  The 07_https-nypl-digital-dev.config is an exception.
If you add it after the EB project is set up in AWS, then 07_https-nypl-digital-dev.config will be ignored.  


Server
========================
In many rails projects when you run the server with `rails s` Rails sets RAILS_ENV to "development".  If you do that with this app, you will connect to the development database on AWS (if you have permission to decrypt the value).  Instead, run `RAILS_ENV=local rails s` to start the server and `RAILS_ENV=local rails c` to run the console.


Testing
========================
First, set up a test database:
bundle exec rake db:drop RAILS_ENV=test
bundle exec rake db:create RAILS_ENV=test
bundle exec rake db:schema:load RAILS_ENV=test

For the unit tests and integration tests, please run the following commands while in the root directory.

```
ruby -Itest test/unit/user_test.rb
ruby -Itest test/unit/book_test.rb
ruby -Itest test/unit/teacher_set_test.rb
ruby -Itest test/unit/ingest_rake_task_test.rb
ruby -Itest test/integration/user_flow_test.rb
ruby -Itest test/functional/exceptions_controller_test.rb
ruby -Itest test/functional/api/v01/bibs_controller_test.rb
```

NOTE:  You might want to pre-pend each command with some environment setup, s.a.:
`RAILS_ENV=local bundle exec rake db:schema:load RAILS_ENV=test`
and
`RAILS_ENV=local ruby -Itest test/unit/user_test.rb`


Order Multiple Teacher Sets Configuration
========================
```
MAXIMUM_COPIES_REQUESTABLE :5  - This is a configuration value in AWS ElasticBeanstalk. In future if anyone want to change the value of maximum teacherset orders, we can update in AWS ElasticBeanstalk Configuration.
```


Show Maintenance Banner Configuration
========================
```SHOW_MAINTENANCE_BANNER: TRUE``` 
This parameter can be set in the ElasticBeanstalk environment's Software config console area.  
The parameter should be set to the string `TRUE` to turn on the banner, which is coded in app/views/layouts/angular.html.erb and app/views/layouts/application.html.erb.
```MAINTENANCE_BANNER_TEXT: 'Maintenance banner text'```
It should be set to the string message that is to appear on the maintenance banner.  It will only appear if the `SHOW_MAINTENANCE_BANNER` parameter above is set to `TRUE`.

Configure localhost for sets and info site
==========================================
```
As of February 2020, the MyLibraryNYC Information site (www.mylibrarynyc.org) has been merged into the Sets application. The Info site was a Rails app, but was created as a lightweight CMS, so the content was stored in the DB in document-oriented models. In merging into the Sets app, we moved away from that model, instead storing the content in regular HTML templates, and having that handled by a single InfoSiteController, as we didn't need the fuller functionality of a CMS.
Additionally, we wanted the two different hostnames to continue working as before — so URLs starting www.mylibrarynyc.org should continue to work as before, as should those starting sets.mylibrarynyc.org. This is achieved by having the routes.rb file check the HOST request header and directing to the appropriate controller accordingly. That further means that to develop both parts of the app, you need to set up special hostnames locally (typically using the /etc/hosts file on Mac OS and other un*x like OSes). Instructions below.
```

```
MacOS X 10.6 through 10.12
Use the following instructions if you’re running MacOS X 10.6 through 10.12:

On your computer, select Applications > Utilities > Terminal to open a Terminal window.
Enter the following command in the Terminal window to open the hosts file:

sudo nano /private/etc/hosts
When you are prompted, enter your domain user password.
Edit the hosts file.

The file contains comments (lines that begin with the # symbol) and some default host name mappings (for example, 127.0.0.1 – local host). Add below new mappings after the default mappings.

127.0.0.1 dev-www.mylibrarynyc.local
127.0.0.1 dev-sets.mylibrarynyc.local

To save the hosts file, press Control+X.
When you are asked if you want to save your changes, enter y.

```

InfoSite code (https://www.mylibrarynyc.org/) into Sets.
========================================================
```
Created info-site files in sets code base(https://sets.mylibrarynyc.org/)

All required javascripts, stylessheets, images files created into sets code -- (assets/javascripts/info-site, assets/stylesheets/info-site, assets/images)

All required info-site-controllers-views-layouts files created(controllers/info_site_controller.rb, views/info-site/**.html.erb, views/layouts/info-site/**.html.erb)

```

Rubocop
========================
```
Running rubocop with no arguments will check all Ruby source files in the current directory:

rubocop

Alternatively you can pass rubocop a list of files and directories to check:

rubocop folder_name/file_name.rb
```


Emails
========================
```
Emailing notifications out of MyLibraryNYC is done through the AWS Simple Email Service.  We turn emails off on the development and local servers by setting

config.action_mailer.perform_deliveries = false
in config/environments/development.rb and local.rb

So if you want to test mailing locally, turn the perform_deliveries back on.
```

Configure ElasticSearch in local
=================================

```
MylibraryNyc project using elastic-search-6.8 version.
Download elastic-search-6.8 version based on OS.

Download elastic-search:
https://www.elastic.co/downloads/past-releases/elasticsearch-6-8-0 

Go to terminal/commandline
cd elasticsearch-6.8.0
Command to start elastic search:  ./bin/elasticsearch

Use below command to create a elastic search cluster.
sh script/elastic_search/create_es_index_mappings.sh
Enter elastic search URL (get elastic search url from elasticsearch.yml or MLN confluence page )
Once ES cluster is created run below method in rails console to update teacherset docs into elastic search cluster.

def create_teacherset_document_in_es
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
end

```

```
Commands to copy database from one environmnet to another
=========================================================

Dump the database which ever your interested in.
'pg_dump' dumps a database as a text file or to other formats.


Run database dump commands:
Command: pg_dump --host={host_name} --username mylibrarynyc --file file_name.out {database_name}

Before restoring database
1) It is recommended to have a back up by talking snapshots of database.
2) Stop all services wherever database being used.

Run below commands in terminal/commandline.

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

MylibaryNYC application local setup
===================================

```
Note: Rails, Ruby and Node installation is required to run project in local.
      Check Ruby and Rails versions in Gemfile.
      https://github.com/NYPL/MyLibraryNYCApp/blob/development/Gemfile

 Step1: Clone git project https://github.com/NYPL/MyLibraryNYCApp.git

 Step2: Go to project path then run "bundle install"

 Step3: Configure aws credentials on local
        Enter a command on terminal:  aws configure
        (get your aws credentials from devops team and enter on terminal)

        [default] 
        aws_access_key_id = ****
        aws_secret_access_key = ****

        [sandbox-user]
        aws_access_key_id = ***
        aws_secret_access_key = ***

        [nypl-digital-dev]
        aws_access_key_id = ***
        aws_secret_access_key = ***

 Step4: Install Postgresql

        Dump the database which ever your interested (Development or QA)

        Run database dump commands:
        Command: pg_dump --host={host_name} --username mylibrarynyc --file file_name.out {database_name}

        Postgresql commands to create database on local:

        psql -l
        psql -d mylibnyc_local
        psql --host localhost --dbname mylibnyc_local -f qa-new_name.out

        Rub below command in project path to create database tables

        RAILS_ENV=local rake db:create
        RAILS_ENV=local rake db:schema:load
        RAILS_ENV=local rake db:migrate
        RAILS_ENV=local rake db:seed

 Step4: Configure elastic search
        MylibraryNyc project using elastic-search-6.8 version.
        Download elastic-search-6.8 version based on OS.

        Download elastic-search:
        https://www.elastic.co/downloads/past-releases/elasticsearch-6-8-0 

        Go to terminal/commandline
        cd elasticsearch-6.8.0
        Command to start elastic search:  ./bin/elasticsearch

        # Run below method to create a teacher-sets in Elastic Search
        def create_teacherset_document_in_es
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
        end

        create_teacherset_document_in_es

Setp5: Run below commands to start server
        
        npm i channels
        RAILS_ENV=local rails s
```
