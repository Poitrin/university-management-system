FROM ruby:2.5
# RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

WORKDIR /tmp
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install

RUN mkdir /ums
WORKDIR /ums
# RUN RAILS_ENV=production bundle exec rake assets:precompile --trace