class Chat < ApplicationRecord
  before_create :set_count
  before_create :set_number

  # model association
  belongs_to :application
  has_many :messages, dependent: :destroy


  private
    def set_count
      self.messages_count = 0
    end

    def set_number
      self.application.chats_count = self.application.chats_count+1
      self.application.save
      self.number = self.application.chats_count

    end
end
