# require 'elasticsearch/model'

class Message < ApplicationRecord
  before_create :increment_messages_count

  # model association
  belongs_to :chat


  def increment_messages_count
    self.chat.increment!(:messages_count)
  end

end
