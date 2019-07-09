class Publisher

  def self.publish(exchange_name, message = {})
    # Returns a connection instance
    conn = Bunny.new(:host => ENV["RABBITMQ_HOST"], :user => ENV["RABBITMQ_USERNAME"], :password => ENV["RABBITMQ_PASSWORD"])
    # The connection is established when start is called
    conn.start

    # create a channel in the TCP connection
    channel = conn.create_channel

    exchange = channel.fanout(exchange_name)

    exchange.publish(message)


    #to remove
    queue = channel.queue('', exclusive: true)
    queue.bind(exchange)

    # fetch a message from the queue
    begin
  queue.subscribe(block: true) do |_delivery_info, _properties, body|
    puts " [x] #{body}"
  end
end

    # grab the fanout exchange
    # x = channel.fanout("chat_system.#{exchange}")
    # # and simply publish message
    # x.publish(message.to_json)
    conn.close
  end

end
