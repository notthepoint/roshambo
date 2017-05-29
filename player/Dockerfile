FROM ruby:latest

ADD . /app

WORKDIR /app

RUN gem install bundler

RUN bundle install

ENTRYPOINT ["ruby", "app.rb"]