class Template < ApplicationRecord
  has_many :letters

  validates :name, presence: true
  validates :content, presence: true
end
