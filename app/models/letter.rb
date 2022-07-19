class Letter < ApplicationRecord
  has_many :letter_sending_dates, dependent: :destroy
  belongs_to :user
  # belongs_to :template

  validates :user_id, presence: true
  # validates :template_id, presence: true
  validates :body, presence: true
  validates :token, presence: true
end
