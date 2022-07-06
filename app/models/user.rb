class User < ApplicationRecord
  has_many :letters, dependent: :destroy
  has_many :letter_sending_dates, dependent: :destroy
  has_many :anniversaries, dependent: :destroy

  validates :line_id, presence: true
end
