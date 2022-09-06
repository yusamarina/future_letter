# == Schema Information
#
# Table name: users
#
#  id           :bigint           not null, primary key
#  role         :integer          default(0), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  line_user_id :string           not null
#
FactoryBot.define do
  factory :user do
    line_user_id { 1 }
  end
end
