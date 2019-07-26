class Chat < ApplicationRecord
  before_create :set_count
  before_create :increment_chats_count

  # model association
  belongs_to :application
  has_many :messages, dependent: :destroy


  private
    def set_count
      self.messages_count = 0
    end

    def increment_chats_count
      self.application.increment!(:chats_count)
    end

end
