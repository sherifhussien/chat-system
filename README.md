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

change to the chat_system directory where we have our docker-compose.yml file
```
$ cd <path_to_docker-compose.yml>
```

build the image
```
$ docker-compose build
```

boot the services. The scale flag create 2 instances if the app services
```
$ docker-compose up -d --scale app=2
```

You need to create and migrate the database
```
$ docker-compose run app rake db:create db:migrate
```

now you have all your services up and running.

## Testing

To check running container, type the following on your terminal:
```
$ docker ps
```

To check the logs of the container
```
$ docker-compose logs app
```
This command will output all the logs since the container has been created, notice how you can now see that the nginx is load balancing on both app instances.
