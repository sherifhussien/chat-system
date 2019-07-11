class Api::V1::ChatsController < ApplicationController

  # GET /api/v1/applications/:application_token/chats
  def index
    message = {
      "action":"getAllChats",
      "attributes":{}
    }

    res = JSON.parse(Publisher.publish("chat_system.worker", message))
    render json: res['payload'], :except =>  ["id", "application_id"], status: :ok
  end

  # # POST /api/v1/applications/:application_token/chats
  def create
    message = {
      "action":"createChat",
      "attributes":{
        "application_token": params[:application_token]
      }
    }
    res = JSON.parse(Publisher.publish("chat_system.worker", message))
    if res['success']
      render json: res['payload'], :except =>  ["id", "application_id"], status: :created
    else
      render json: res['payload'], status: :bad_request
    end

  end

  # PUT /api/v1/applications/:application_token/chats/1
  # no need but implemented as required to show the update action
  def update
    message = {
      "action":"updateChat",
      "attributes":{
        "application_token": params[:application_token],
        "number": params[:number],
        "messages_count": params[:messages_count]
      }
    }
    res = JSON.parse(Publisher.publish("chat_system.worker", message))

    if res['success']
      render json: res['payload'], :except =>  ["id", "application_id"], status: :ok
    else
      render json: res['payload'], status: :bad_request
    end
  end
end
