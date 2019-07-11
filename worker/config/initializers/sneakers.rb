module Connection
  def self.sneakers
    @_sneakers ||= begin
      Bunny.new(:host => ENV["RABBITMQ_HOST"], :user => ENV["RABBITMQ_USERNAME"], :password => ENV["RABBITMQ_PASSWORD"])
    end
  end
end


Sneakers.configure  :connection => Connection.sneakers,
                    :exchange => 'chat_system.worker',
                    :exchange_type => :fanout,
                    :workers => 1

Sneakers.logger.level = Logger::INFO
