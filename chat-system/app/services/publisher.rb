class Publisher
  def self.publish(exchange, message = {})
    # grab the fanout exchange
    x1 = channel.fanout(exchange)

    x2 = channel.fanout("chat_system.app")
    q = channel.queue("").bind(x2)


    # and simply publish message
    x1.publish(message.to_json)
    sleep 1
    delivery_info, properties, payload = q.pop
    payload
  end

  def self.channel
    @channel ||= connection.create_channel
  end

  def self.connection
    if(@connection.nil?)
      @connection = Bunny.new(:host => ENV["RABBITMQ_HOST"], :user => ENV["RABBITMQ_USERNAME"], :password => ENV["RABBITMQ_PASSWORD"])
      @connection.start
    end
  end
end
