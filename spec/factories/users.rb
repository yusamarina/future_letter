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
