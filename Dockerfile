FROM ruby:2.3

RUN apt-get update -yqq \
  && apt-get install -yqq --no-install-recommends mysql-client \
  && rm -rf /var/lib/apt/lists

WORKDIR /app
COPY Gemfile* ./
RUN bundle install
COPY . .

EXPOSE 3000
