FROM ruby:3.0.0

HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD curl -f http://localhost/ || exit 1

WORKDIR /app

COPY . /app

RUN bundle install

RUN chmod +x ./src/ccwc.rb

RUN useradd -ms /bin/bash appuser
USER appuser

ENTRYPOINT [ "./src/ccwc.rb" ]
