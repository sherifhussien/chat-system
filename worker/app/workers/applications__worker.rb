class ApplicationsWorker
  include Sneakers::Worker
  from_queue 'worker',
              :exchange => 'chat_system.worker',
              :durable => false,
              :ack => true

  def work(msg)
    request = JSON.parse(msg)

    if request["action"] == "createApplication"

      Handler.createApplication(request)

    elsif request["action"] == "updateApplication"

      Handler.updateApplication(request)

    elsif request["action"] == "createChat"

      Handler.createChat(request)

    elsif request["action"] == "updateChat"

      Handler.updateChat(request)

    elsif request["action"] == "createMessage"

      Handler.createMessage(request)

    elsif request["action"] == "updateMessage"

      Handler.updateMessage(request)
    end

  end

end
