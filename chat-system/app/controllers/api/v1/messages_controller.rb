class Api::V1::MessagesController < ApplicationController
  # GET /api/v1/applications/:application_token/chats/:chat_number/messages
  def index
    message = {
      "action":"getAllMessages",
      "attributes":{
        "application_token": params[:application_token],
        "chat_number": params[:chat_number]
      }
    }

    res = JSON.parse(Publisher.publish("chat_system.worker", message))
    render json: res['payload'], :except =>  ["id", "application_id", "chat_id"], status: :ok
  end

  # POST /api/v1/applications/:application_token/chats/:chat_number/messages
  def create
    message = {
      "action":"createMessage",
      "attributes":{
        "application_token": params[:application_token],
        "chat_number": params[:chat_number],
        "content": params[:content]
      }
    }
    res = JSON.parse(Publisher.publish("chat_system.worker", message))
    if res['success']
      render json: res['payload'], :except =>  ["id", "application_id", "chat_id"], status: :created
    else
      render json: res['payload'], status: :bad_request
    end

  end

  # PUT /api/v1/applications/:application_token/chats/:chat_number/messages/:number
  def update
    message = {
      "action":"updateMessage",
      "attributes":{
        "application_token": params[:application_token],
        "chat_number": params[:chat_number],
        "number": params[:number],
        "content": params[:content]
      }
    }
    res = JSON.parse(Publisher.publish("chat_system.worker", message))

    if res['success']
      render json: res['payload'], :except =>  ["id", "application_id", "chat_id"], status: :ok
    else
      render json: res['payload'], status: :bad_request
    end
  end
end
