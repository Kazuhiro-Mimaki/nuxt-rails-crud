FROM ruby:2.7.0

RUN apt-get update -qq && \
  apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  postgresql-client

WORKDIR /app

COPY Gemfil Gemfile.lock /app/
RUN bundle install