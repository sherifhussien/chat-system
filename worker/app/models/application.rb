class Application < ApplicationRecord
  before_create :set_count

  # By default, Rails assumes that the attribute name is token.
  # We can provide a different name as a parameter to has_secure_token if the attribute name is not token
  has_secure_token

  # model association
  has_many :chats, dependent: :destroy

  # validations
  validates :name, presence: true


  private
    def set_count
      self.chats_count = 0
    end
end
