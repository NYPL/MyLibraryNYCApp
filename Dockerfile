# syntax = docker/dockerfile:1.3
FROM ruby:2.7.4 AS builder

# set env vars
ENV APP_HOME /home/app/MyLibraryNYCApp
ENV AWS_DEFAULT_REGION=us-east-1

ARG RAILS_ENV
ENV RAILS_ENV=${RAILS_ENV}

WORKDIR $APP_HOME

# install packages
RUN apt-get update -qq \
    && apt-get install -y \
    curl \
    postgresql-client \
    git

RUN curl -sL https://deb.nodesource.com/setup_14.x  | bash - \
    && apt-get -y install nodejs \
    && npm install --global yarn

# set up app files
COPY . $APP_HOME
COPY Gemfile $APP_HOME
COPY Gemfile.lock $APP_HOME
WORKDIR $APP_HOME

## bundle
RUN gem install bundler
RUN bundle config --global github.https true \
    && bundle install --jobs 30

# mount AWS creds in a single layer
RUN --mount=type=secret,id=AWS_ACCESS_KEY_ID \
    --mount=type=secret,id=AWS_SECRET_ACCESS_KEY \
  AWS_ACCESS_KEY_ID=$(cat /run/secrets/AWS_ACCESS_KEY_ID) \
  && export AWS_ACCESS_KEY_ID \
  AWS_SECRET_ACCESS_KEY=$(cat /run/secrets/AWS_SECRET_ACCESS_KEY) \
  && export AWS_SECRET_ACCESS_KEY \
  && bundle exec rails webpacker:install \
  && bundle exec rails webpacker:compile

# webpack overwrites these files
COPY config/webpacker.yml $APP_HOME/config/
COPY config/webpack/environment.js $APP_HOME/config/webpack/
COPY babel.config.js $APP_HOME

EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-p", "3000", "-b", "0.0.0.0"]
