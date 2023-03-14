FROM phusion/passenger-ruby27:2.0.1 AS production

# set env vars
ENV HOME /root
ENV RUBY_VERSION=2.7.4
ENV APP_HOME /home/app/MyLibraryNYCApp

# use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# remove passenger apt repository from list
# fixes this error - "The repository 'https://oss-binaries.phusionpassenger.com/apt/passenger bionic Release' does not have a Release file."
RUN cat /dev/null > /etc/apt/sources.list.d/passenger.list

RUN apt-get update -qq \
    && apt-get install -y \
    git

# set up app files
COPY --chown=app:app . $APP_HOME
COPY Gemfile $APP_HOME
COPY Gemfile.lock $APP_HOME
WORKDIR $APP_HOME

## bundle
RUN gem install bundler -v '2.2.28' 
RUN bash -lc "rvm use ruby-$RUBY_VERSION --default"
#RUN bash -lc "rvm install ruby-$RUBY_VERSION && rvm use ruby-$RUBY_VERSION --default"
RUN bundle config --global github.https true \
    && bundle install

FROM production AS development

RUN apt-get install -y postgresql-client

RUN cd $APP_HOME && bundle --with test development
