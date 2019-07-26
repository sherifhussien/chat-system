class Handler

  def self.createApplication(request)
    @application = Application.create({name: request['attributes']['name']})
  end

  def self.updateApplication(request)
    @application = Application.find_by(token: request['attributes']['token'])
    @application.update({name: request['attributes']['name']})
  end


  def self.createChat(request)
    @application = Application.find_by(token: request['attributes']['application_token'])
    @chat = @application.chats.create!(number: request['attributes']['number'])
  end

  def self.updateChat(request)
    @application = Application.find_by(token: request['attributes']['application_token'])
    @chat = @application.chats.find_by!(number: request['attributes']['number']) if @application
    @chat.update({messages_count: request['attributes']['messages_count']})
  end

  def self.createMessage(request)
    @application = Application.find_by(token: request['attributes']['application_token'])
    @chat = Chat.find_by!(number: request['attributes']['chat_number'])
    @message = @chat.messages.create!({content: request['attributes']['content'], number: request['attributes']['number']})
  end

  def self.updateMessage(request)
    @application = Application.find_by(token: request['attributes']['application_token'])
    @chat = @application.chats.find_by!(number: request['attributes']['chat_number']) if @application
    @message = @chat.messages.find_by!(number: request['attributes']['number']) if @chat
    @message.update({content: request['attributes']['content']})
  end

end
