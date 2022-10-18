# == Schema Information
#
# Table name: users
#
#  id           :bigint           not null, primary key
#  role         :integer          default("general"), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  line_user_id :string           not null
#
# Indexes
#
#  index_users_on_line_user_id  (line_user_id) UNIQUE
#
class User < ApplicationRecord
  has_many :letters, dependent: :destroy
  has_many :send_letters, foreign_key: :destination_id, dependent: :destroy
  has_many :anniversaries, dependent: :destroy

  validates :line_user_id, presence: true, uniqueness: true

  enum role: { general: 0, admin: 1 }

end
