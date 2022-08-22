class Anniversary < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :date, presence: true
  validates :description, length: { maximum: 150 }

end
