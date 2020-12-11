# Ruby on Rails&Nuxt.ts on docker-compose sample

## Setup for local development
Please install [Docker](https://store.docker.com/search?type=edition&offering=community) on your local environment before setup.

```sh
$ git clone git@github.com:Kazuhiro-Mimaki/nuxt-rails-crud.git
$ cd nuxt-rails-crud
$ docker-compose build
$ docker-compose up -d

# Setup for db
$ docker-compose exec server-side bundle exec rails db:create
$ docker-compose exec server-side bundle exec rails db:migrate

# Open
$ open http://localhost:8000
```