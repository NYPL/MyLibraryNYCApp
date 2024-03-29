# syntax = docker/dockerfile:1.3
FROM ruby:2.7.4 AS builder

# set env vars
ENV APP_HOME /home/app/MyLibraryNYCApp
ENV AWS_DEFAULT_REGION=us-east-1

ARG RAILS_ENV
ENV RAILS_ENV=${RAILS_ENV}

WORKDIR $APP_HOME
ADD ./docker_build/startup_scripts/01_db_migrate.sh /etc/my_init.d/01_db_migrate.sh

# install packages
RUN apt-get update -qq \
    && apt-get install -y \
    curl \
    postgresql-client \
    git

RUN curl -sL https://deb.nodesource.com/setup_16.x  | bash - \
    && apt-get -y install nodejs \
    && npm install --global yarn

# Install esbuild
RUN npm install -g esbuild

# set up app files
COPY . $APP_HOME
COPY Gemfile $APP_HOME
COPY Gemfile.lock $APP_HOME
WORKDIR $APP_HOME

## bundle
ENV BUNDLER_VERSION=2.4.22
RUN gem install bundler -v $BUNDLER_VERSION
RUN bundle config --global github.https true \
    && bundle install --jobs 30

COPY package.json $APP_HOME/package.json
COPY package-lock.json $APP_HOME/package-lock.json
RUN yarn install

# build
RUN yarn build
RUN yarn build:css

RUN --mount=type=secret,id=AWS_ACCESS_KEY_ID \
    --mount=type=secret,id=AWS_SECRET_ACCESS_KEY \
  AWS_ACCESS_KEY_ID=$(cat /run/secrets/AWS_ACCESS_KEY_ID) \
  && export AWS_ACCESS_KEY_ID \
  AWS_SECRET_ACCESS_KEY=$(cat /run/secrets/AWS_SECRET_ACCESS_KEY) \
  && export AWS_SECRET_ACCESS_KEY \
  && bundle exe rails assets:precompile

# Install PostgreSQL client in the image
RUN apt-get update -qq && apt-get install -y postgresql-client

EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-p", "3000", "-b", "0.0.0.0"]
