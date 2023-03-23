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

## bundle
FROM ruby:2.7.4 as bundler
WORKDIR /tmp
RUN gem install bundler
COPY Gemfile Gemfile.lock . /tmp
RUN bundle config --global github.https true \
    && bundle install --jobs 30

FROM ruby:2.7.4 as app
RUN mkdir -p /rails
WORKDIR /rails
COPY --from=bundler /usr/local/bundle /usr/local/bundle

RUN npm install --global yarn

RUN yarn config delete https-proxy && \
			yarn config delete proxy

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
