class Api::V1::MessagesController < ApplicationController
  # GET /api/v1/applications/:application_token/chats/:chat_number/messages
  def index
    @messages = fetch_messages_redis
    render json: @messages, :except =>  ["id", "application_id", "chat_id"], status: :ok
  end

  # POST /api/v1/applications/:application_token/chats/:chat_number/messages
  def create
    number = fetch_messages_count_redis
    message = {
      "action":"createMessage",
      "attributes":{
        "application_token": params[:application_token],
        "chat_number": params[:chat_number],
        "number": number,
        "content": params[:content]
      }
    }
    Publisher.publish("chat_system.worker", message)

    response = {
      "number": number
    }
    render json: response, :except =>  ["id"], status: :ok

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
    Publisher.publish("chat_system.worker", message)

    response = {
      "message":"updated message number #{params[:number]} for chat number #{params[:chat_number]} for application #{params[:application_token]} with content: #{params[:content]}"
    }

    render json: response, :except =>  ["id"], status: :ok
  end

  def fetch_messages_redis
    messages = $redis.get("#{params['application_token']}_#{params['chat_number']}_messages")  #This line requests redis-server to accepts any value associate with articles key
    if messages.nil?  #this condition will executes if any articles not available on redis server
      application = Application.find_by(token: params['application_token'])
      chat = application.chats.find_by!(number: params['chat_number'])
      messages = chat.messages.to_json
      $redis.set("#{params['application_token']}_#{params['chat_number']}_messages", messages)
      $redis.expire("#{params['application_token']}_#{params['chat_number']}_messages", 10.seconds.to_i)
    end

    JSON.load messages #This will converts JSON data to Ruby Hash
  end

  def fetch_messages_count_redis
    unless $redis.exists("#{params['application_token']}_#{params['chat_number']}_messages_count")
      application = Application.find_by(token: params['application_token'])
      chat = application.chats.find_by(number: params['chat_number'])
      $redis.set("#{params['application_token']}_#{params['chat_number']}_messages_count", chat.messages_count)
    end

    $redis.incr("#{params['application_token']}_#{params['chat_number']}_messages_count")
  end
end
