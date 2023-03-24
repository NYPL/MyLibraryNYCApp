FROM ruby:2.7.4 AS builder

# set env vars
ENV APP_HOME /home/app/MyLibraryNYCApp
ENV RAILS_ENV=qa
ENV AWS_DEFAULT_REGION=us-east-1
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY

RUN apt-get update -qq \
    && apt-get install -y \
    curl \
    postgresql-client \
    git

RUN curl -sL https://deb.nodesource.com/setup_14.x  | bash -
RUN apt-get -y install nodejs

# set up app files
COPY . $APP_HOME
COPY Gemfile $APP_HOME
COPY Gemfile.lock $APP_HOME
WORKDIR $APP_HOME

## bundle
RUN gem install bundler
RUN bundle config --global github.https true \
    && bundle install --jobs 30

RUN npm install --global yarn

## webpacker needs this which is super annoying!! 
ENV AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
ENV AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
RUN bundle exec rails webpacker:install
# Overwrite /home/app/MyLibraryNYCApp/config/webpacker.yml? (enter "h" for help) [Ynaqdhm] 
# Overwrite /home/app/MyLibraryNYCApp/config/webpack/environment.js? (enter "h" for help) [Ynaqdhm] 
# Overwrite /home/app/MyLibraryNYCApp/babel.config.js? 

RUN bundle exec rails webpacker:compile

EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-p", "3000", "-b", "0.0.0.0"]
