FROM ruby:3.0.0

WORKDIR /app

COPY . /app

RUN bundle install

RUN chmod +x ./src/ccwc.rb

ENTRYPOINT [ "./src/ccwc.rb" ]
