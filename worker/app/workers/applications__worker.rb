class ApplicationsWorker
  include Sneakers::Worker
  from_queue 'worker',
              :exchange => 'chat_system.worker',
              :durable => false,
              :ack => true

  def work(msg)
    request = JSON.parse(msg)

    response = {}
    response['success'] = true
    if request["action"] == "getAllApplications"

      response['payload'] = Application.all

    elsif request["action"] == "createApplication"

      @application = Application.new({name: request['attributes']['name']})
      if @application.save
        response['payload'] = @application
      else
        response['payload'] = @application.errors
        response['success'] = false
      end

    elsif request["action"] == "updateApplication"

      @application = Application.find_by(token: request['attributes']['token'])
      if @application.update({name: request['attributes']['name']})
        response['payload'] = @application
      else
        response['payload'] = @application.errors
        response['success'] = false

      end
    elsif request["action"] == "getAllChats"
      response['payload'] = Chat.all
    elsif request["action"] == "createChat"

      @application = Application.find_by(token: request['attributes']['application_token'])
      @chat = @application.chats.create!()
      response['payload'] = @chat

    elsif request["action"] == "updateChat"

      @application = Application.find_by(token: request['attributes']['application_token'])
      @chat = @application.chats.find_by!(number: request['attributes']['number']) if @application
      if @chat.update({messages_count: request['attributes']['messages_count']})
        response['payload'] = @chat
      else
        response['payload'] = @chat.errors
        response['success'] = false
      end

    elsif request["action"] == "getAllMessages"
      response['payload'] = Message.all
    elsif request["action"] == "createMessage"

      @application = Application.find_by(token: request['attributes']['application_token'])
      @chat = Chat.find_by!(number: request['attributes']['chat_number'])
      @message = @chat.messages.create!({content: request['attributes']['content']})
      response['payload'] = @message

    elsif request["action"] == "updateMessage"

      @application = Application.find_by(token: request['attributes']['application_token'])
      @chat = @application.chats.find_by!(number: request['attributes']['chat_number']) if @application
      @message = @chat.messages.find_by!(number: request['attributes']['number']) if @chat

      if @message.update({content: request['attributes']['content']})
        response['payload'] = @message
      else
        response['payload'] = @message.errors
        response['success'] = false
      end
    end


    Publisher.publish("chat_system.app", response)
    ack!
  end

end
