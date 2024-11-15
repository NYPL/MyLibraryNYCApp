#!/bin/bash
RAILS_ENV=development bundle exec rake db:create db:migrate db:seed
RAILS_ENV=test bundle exec rake db:create db:schema:load
