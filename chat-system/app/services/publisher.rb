class Publisher
  def self.publish(exchange, message = {})
    # grab the fanout exchange
    x1 = channel.fanout(exchange)
    
    # and simply publish message
    x1.publish(message.to_json)
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
