MyLibraryNYC
============

My Library NYC Mobile Pilot

For a description of what this is, check the [wiki](https://confluence.nypl.org/display/WT/My+Library+NYC).


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
```
SHOW_MAINTENANCE_BANNER: TRUE  - This is a configuration value in AWS ElasticBeanstalk. In future if anyone want to change the value of maintenanct banner, we can update in AWS ElasticBeanstalk Configuration.

This parameter should be set to the string true to turn on the banner, which is set in app/views/layouts/angular.html.erb and app/views/layouts/application.html.erb.

MAINTENANCE_BANNER_TEXT: 'Maintenance banner text'

This parameter should be set to the string true to turn on the banner, which is set in the MAINTENANCE_BANNER_TEXT environment variable.
```


Show Maintenance Banner Configuration
========================
SHOW_MAINTENANCE_BANNER: TRUE
This parameter can be set in the ElasticBeanstalk AWS console. 
It should be set to the string 'TRUE' to turn on the banner. The banner text is set in the `MAINTENANCE_BANNER_TEXT` parameter, below.

MAINTENANCE_BANNER_TEXT: 'Maintenance banner text' 
This parameter can be set in the ElasticBeanstalk AWS console. 
It should be set to the value which we wish to appear in the banner. It will only appear if the `SHOW_MAINTENANCE_BANNER` parameter above is set to `TRUE`.


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
