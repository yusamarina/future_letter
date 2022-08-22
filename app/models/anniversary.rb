class Anniversary < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :date, presence: true
  validates :name, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 150 }

end
