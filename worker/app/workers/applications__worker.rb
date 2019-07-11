class ApplicationsWorker
  include Sneakers::Worker
  from_queue 'worker',
              :exchange => 'chat_system.worker',
              :durable => false,
              :ack => true

  def work(msg)
    request = JSON.parse(msg)

    response = {}
    if request["action"] == "getAllApplications"

      response = Handler.getAllApplications(request)

    elsif request["action"] == "createApplication"

      response = Handler.createApplication(request)

    elsif request["action"] == "updateApplication"

      response = Handler.updateApplication(request)

    elsif request["action"] == "getAllChats"

      response = Handler.getAllChats(request)

    elsif request["action"] == "createChat"

      response = Handler.createChat(request)

    elsif request["action"] == "updateChat"

      response = Handler.updateChat(request)


    elsif request["action"] == "getAllMessages"

      response = Handler.getAllMessages(request)

    elsif request["action"] == "createMessage"

      response = Handler.createMessage(request)


    elsif request["action"] == "updateMessage"

      response = Handler.updateMessage(request)

    elsif request["action"] == "searchMessages"

      response = Handler.searchMessages(request)

    end


    Publisher.publish("chat_system.app", response)
    ack!
  end

end
