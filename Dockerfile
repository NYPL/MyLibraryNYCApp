FROM ruby:2.7.4

RUN apt-get update -qq && apt-get install -y postgresql-client


RUN mkdir /app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install
COPY . /app

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
