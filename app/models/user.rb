class User < ApplicationRecord
  has_many :letters, dependent: :destroy
  has_many :send_letters, foreign_key: :destination_id, dependent: :destroy
  has_many :anniversaries, dependent: :destroy

  validates :line_user_id, presence: true
end
