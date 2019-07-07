# Chat System API

Instabug backend challenge to build a chat system API using Ruby on Rails(V5)

## Getting Started

These instructions will get you the project up and running on your local machine for development and testing purposes

### Prerequisites

Install both docker and docker-compose on your local machine.

To make sure they were installed successfully, type the following on your terminal:

```
$ docker --version
$ docker-compose --version
```



## Setup

* change to the chat_system directory where we have our docker-compose.yml file

```
$ cd <path_to_docker-compose.yml>
```

* build the image

```
$ docker-compose build
```

* boot the app

```
$ docker-compose up -d
```

* You need to create and migrate the database

```
$ docker-compose run app rake db:create db:migrate
```

now you have all your services up and running.
