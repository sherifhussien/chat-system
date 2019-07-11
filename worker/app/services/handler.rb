class Handler
  def self.getAllApplications(request)
    response = {}
    response['success'] = true
    response['payload'] = Application.all
    return response
  end

  def self.createApplication(request)
    @application = Application.new({name: request['attributes']['name']})
    response = {}
    if @application.save
      response['payload'] = @application
      response['success'] = true
    else
      response['payload'] = @application.errors
      response['success'] = false
    end
    return response
  end

  def self.updateApplication(request)
    response = {}
    @application = Application.find_by(token: request['attributes']['token'])
    if @application.update({name: request['attributes']['name']})
      response['payload'] = @application
      response['success'] = true
    else
      response['payload'] = @application.errors
      response['success'] = false
    end
    return response
  end

  def self.getAllChats(request)
    @application = Application.find_by(token: request['attributes']['application_token'])

    response = {}
    response['success'] = true
    response['payload'] = @application.chats
    return response
  end

  def self.createChat(request)
    response = {}
    response['success'] = true

    @application = Application.find_by(token: request['attributes']['application_token'])
    @chat = @application.chats.create!()
    response['payload'] = @chat
    return response
  end

  def self.updateChat(request)
    response = {}

    @application = Application.find_by(token: request['attributes']['application_token'])
    @chat = @application.chats.find_by!(number: request['attributes']['number']) if @application
    if @chat.update({messages_count: request['attributes']['messages_count']})
      response['payload'] = @chat
      response['success'] = true
    else
      response['payload'] = @chat.errors
      response['success'] = false
    end
    return response
  end

  def self.getAllMessages(request)
    @application = Application.find_by(token: request['attributes']['application_token'])
    @chat = Chat.find_by!(number: request['attributes']['chat_number'])
    response = {}
    response['payload'] = @chat.messages
    response['success'] = true
    return response
  end

  def self.createMessage(request)
    response = {}
    @application = Application.find_by(token: request['attributes']['application_token'])
    @chat = Chat.find_by!(number: request['attributes']['chat_number'])
    @message = @chat.messages.create!({content: request['attributes']['content']})
    response['payload'] = @message
    response['success'] = true
    return response
  end

  def self.updateMessage(request)
    response = {}
    @application = Application.find_by(token: request['attributes']['application_token'])
    @chat = @application.chats.find_by!(number: request['attributes']['chat_number']) if @application
    @message = @chat.messages.find_by!(number: request['attributes']['number']) if @chat
    if @message.update({content: request['attributes']['content']})
      response['payload'] = @message
      response['success'] = true
    else
      response['payload'] = @message.errors
      response['success'] = false
    end
    return response
  end

  def self.searchMessages(request)
    response = {}
    @application = Application.find_by(token: request['attributes']['application_token'])
    @chat = @application.chats.find_by!(number: request['attributes']['chat_number']) if @application
    @messages = @chat.messages.search(request['attributes']['q'])
    response['payload'] = @messages
    response['success'] = true
    return response
  end

end
