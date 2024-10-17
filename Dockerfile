# Set base image and working directory
FROM ruby:3.3 AS ruby-builder

# Install necessary packages, including curl and PostgreSQL client
RUN apt-get update -qq && apt-get install -y \
  curl \
  postgresql-client \
  && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
  && apt-get install -y nodejs \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install Yarn globally
#RUN npm install -g yarn

# Set environment variables
ENV RAILS_ENV=development
ENV APP_HOME=/app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# Install esbuild globally
RUN npm install -g esbuild

# Copy Gemfile and Gemfile.lock first
COPY Gemfile Gemfile.lock $APP_HOME/

# Install bundler and Ruby dependencies
RUN gem install bundler -v 2.5.20
#RUN bundle config --global  without 'jruby_gems'
RUN bundle install --jobs 30

# Use JRuby for building and installing the Logstash gem
FROM --platform=linux/amd64 jruby:9.4.8.0 AS logstash-builder
WORKDIR /logstash
RUN apt-get update --allow-unauthenticated && apt-get install -y git
#RUN apt-get update --allow-unauthenticated
#RUN apt-get install debian-archive-keyring
#RUN gem install logstash-event -v 8.15.2
COPY Gemfile.jruby $APP_HOME/
RUN gem install bundler -v 2.5.20
ENV BUNDLE_GEMFILE=/Gemfile.jruby
RUN bundle install --jobs 30

# Final stage, merging the builds
FROM ruby:3.3

# Install Node.js and Yarn in the final stage
RUN apt-get update -qq && apt-get install -y \
  curl \
  && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
  && apt-get install -y nodejs \
  && npm install -g yarn \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Set up working directory
ENV APP_HOME=/app
WORKDIR $APP_HOME

# Copy the Ruby application files from the ruby-builder stage
COPY --from=ruby-builder $APP_HOME $APP_HOME

# Copy the logstash gem from the logstash-builder stage
COPY --from=logstash-builder /usr/local/bundle /usr/local/bundle

ENV PATH $APP_HOME/bin:/usr/local/bundle/bin:$PATH
ENV BUNDLE_GEMFILE=/Gemfile

# Copy package.json and package-lock.json before running yarn install
COPY package.json $APP_HOME/

# Install JS dependencies
RUN yarn install

# Now copy the rest of the application
COPY . $APP_HOME/

# Precompile assets
RUN yarn build
RUN yarn build:css

# Expose the app port
EXPOSE 3000

# Start the server
CMD ["bash", "-c", "rm -f /app/tmp/pids/server.pid && bundle exec rails server -b 0.0.0.0"]
