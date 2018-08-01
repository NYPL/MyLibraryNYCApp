#!/bin/bash

# Script to run ingest, backup, and update_availability rake tasks

# Suggested crontab entries:
# 
# Backup at 2:35 est daily
#   35 2 * * * /home/ubuntu/apps/MyLibraryNYC/script/run_rake_ingest.sh backup
# Ingest at 3:05 est daily
#   5 3 * * * /home/ubuntu/apps/MyLibraryNYC/script/run_rake_ingest.sh ingest
# Update set availability every 2hrs between 8:05am and 8:05pm
#   5 8,10,12,14,16,18,20 * * * /home/ubuntu/apps/MyLibraryNYC/script/run_rake_ingest.sh update_availability

if [ -z "$1" ]; then
  echo "Specify ingest task"
  exit
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

export set BIBLIO_KEY=b96udzc9jbr3fmat7avhbtsd
export set DATABASE_URL=$(heroku config:get DATABASE_URL -a mylibrarynyc) 
rake ingest:$1

cd -

