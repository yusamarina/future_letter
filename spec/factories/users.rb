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
FactoryBot.define do
  factory :user do
    sequence(:line_user_id) { |n| "test_user_id_#{n}" }
    role { 0 }
  end

  trait :admin do
    role { 1 }
  end

  trait :general do
    role{ 0 }
  end
end
