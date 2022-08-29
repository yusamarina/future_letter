# == Schema Information
#
# Table name: anniversaries
#
#  id          :bigint           not null, primary key
#  date        :datetime         not null
#  description :text
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_anniversaries_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Anniversary < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :date, presence: true
  validates :name, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 150 }

end
