class Api::V1::ChatsController < ApplicationController

  # GET /api/v1/applications/:application_token/chats
  def index
    @chats = fetch_chats_redis
    render json: @chats, :except =>  ["id", "application_id"], status: :ok
  end

  # # POST /api/v1/applications/:application_token/chats
  def create
    number = fetch_chats_count_redis
    message = {
      "action":"createChat",
      "attributes":{
        "application_token": params[:application_token],
        "number": number
      }
    }

    Publisher.publish("chat_system.worker", message)

    response = {
      "number": number
    }

    render json: response, :except =>  ["id"], status: :ok
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
    Publisher.publish("chat_system.worker", message)

    response = {
      "message":"updated chat number #{params[:number]} for application #{params[:application_token]} with message_count: #{params[:messages_count]}"
    }

    render json: response, :except =>  ["id"], status: :ok
  end


  def fetch_chats_redis
    chats = $redis.get("#{params['application_token']}_chats")  #This line requests redis-server to accepts any value associate with articles key
    if chats.nil?  #this condition will executes if any articles not available on redis server
      application = Application.find_by(token: params['application_token'])
      chats = application.chats.to_json
      $redis.set("#{params['application_token']}_chats", chats)
      $redis.expire("#{params['application_token']}_chats", 10.seconds.to_i)
    end

    JSON.load chats #This will converts JSON data to Ruby Hash
  end

  def fetch_chats_count_redis
    unless $redis.exists("#{params['application_token']}_chats_count")
      application = Application.find_by(token: params['application_token'])
      $redis.set("#{params['application_token']}_chats_count", application.chats_count)
    end

    $redis.incr("#{params['application_token']}_chats_count")
  end

end
