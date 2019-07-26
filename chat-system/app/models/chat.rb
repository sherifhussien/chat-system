class Chat < ApplicationRecord

  # model association
  belongs_to :application
  has_many :messages, dependent: :destroy

end
