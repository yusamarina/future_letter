class LetterSendingDate < ApplicationRecord
  belongs_to :letter
  belongs_to :user, class_name: 'User', foreign_key: :destination_id

  validates :destination_id, presence: true
  validates :letter_id, presence: true
  validates :send_date, presence: true
end
