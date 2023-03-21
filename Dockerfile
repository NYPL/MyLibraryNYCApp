FROM phusion/passenger-ruby27:2.0.1 AS production

# set env vars
ENV RUBY_VERSION=2.7.4
ENV APP_HOME /home/app/MyLibraryNYCApp

# use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# remove passenger apt repository from list
# fixes this error - "The repository 'https://oss-binaries.phusionpassenger.com/apt/passenger bionic Release' does not have a Release file."
RUN cat /dev/null > /etc/apt/sources.list.d/passenger.list

RUN apt-get update -qq \
    && apt-get install -y \
    npm \
    git

# set up app files
COPY --chown=app:app . $APP_HOME
COPY Gemfile $APP_HOME
COPY Gemfile.lock $APP_HOME
WORKDIR $APP_HOME

RUN npm install --global yarn \
    npm i webpack-dev-server

## bundle
RUN gem install bundler
RUN bash -lc "rvm use ruby-$RUBY_VERSION --default"

RUN bundle config --global github.https true \
    && bundle install

RUN bundle exec rails webpacker:install
#RUN bundle exec rails webpacker:install:react
#RUN bundle exec rails webpacker:compile

yarn add @rails/webpacker


FROM production AS development

RUN apt-get install -y postgresql-client

EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-p", "3000", "-b", "0.0.0.0"]
