# == Schema Information
#
# Table name: templates
#
#  id         :bigint           not null, primary key
#  content    :string           not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Template < ApplicationRecord
  has_many :letters

  validates :name, presence: true
  validates :content, presence: true
end
