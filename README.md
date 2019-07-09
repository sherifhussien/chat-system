# Chat System API

Build a chat system API using Ruby on Rails(V5)

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

boot the services. The scale flag create 2 instances of the app service
```
$ docker-compose up -d --scale app=2
or
$ docker-compose up --scale app=2 
```

You need to create and migrate the database
```
$ docker-compose run app rake db:create db:migrate
```

now you have all your services up and running.

### Testing

To check running containers, type the following on your terminal:
```
$ docker ps
```

if you docker-compose is running on the background, you can check the logs of the app container using the following command
```
$ docker-compose logs app
```
This command will output all the logs since the container has been created, notice how you can now see that the nginx is load balancing on both app instances.

For __RabbitMQ__, you can access its GUI from your browser via `http://localhost:15672` with user:password

## How to use

First make sure you have postman app on your local machine to be able to construct requests and read responses easily.

`localhost:4000` is the main entry to our api service. For example, request will be in the form `localhost:4000/api/v1/applications`, where `/api/v1/applications` is the route for getting list of applications

Following are the routes provided by our service, make sure to set the params and action of each request as stated

### Application
* `GET /api/v1/applications` => gets the list of all applications
* `POST /api/v1/applications?name=app_name` => creates an app with the name app_name provided in the params
* `PUT /api/v1/applications/:token`  => updates an app

### Chat
* `GET /api/v1/applications/:application_token/chats` => gets the list of all chats of a certain application
* `POST //api/v1applications/:application_token/chats` => creates a chat for a certain application
* `PUT /api/v1/applications/:application_token/chats/:number`  => updates a chat of a certain application

### Message
* `GET /api/v1/applications/:application_token/chats/:chat_number/messages` => gets the list of all messages of a certain chat and application
* `POST /api/v1/applications/:application_token/chats/:chat_number/messages` => creates a chat for a certain chat and application
* `PUT /api/v1/applications/:application_token/chats/:chat_number/messages/:number`  => updates a message of a certain chat and application
