FROM ruby:2.4.2-jessie
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs imagemagick
RUN mkdir /tweet-archive
WORKDIR /tweet-archive
ADD Gemfile /tweet-archive/Gemfile
ADD Gemfile.lock /tweet-archive/Gemfile.lock
RUN bundle install
ADD . /tweet-archive
