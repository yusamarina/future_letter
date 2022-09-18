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
FactoryBot.define do
  factory :anniversary do
    date { Date.today }
    name { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    user
  end
end
