# Set base image and working directory
FROM ruby:3.3

# Install necessary packages, including curl and PostgreSQL client
RUN apt-get update -qq && apt-get install -y \
  curl \
  postgresql-client \
  && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
  && apt-get install -y nodejs \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install Yarn globally
RUN npm install -g yarn

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
RUN gem install bundler #-v 2.4.22
RUN bundle install --jobs 30

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
