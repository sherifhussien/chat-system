FROM ruby:2.5.5

RUN apt-get update -yqq \
  && apt-get install -yqq --no-install-recommends \
    build-essential \
    nodejs \
    mysql-client \
  && apt-get -q clean \
  && rm -rf /var/lib/apt/lists


WORKDIR /app
COPY Gemfile* ./
RUN bundle install
COPY . ./
