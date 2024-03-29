# == Schema Information
#
# Table name: letters
#
#  id          :bigint           not null, primary key
#  body        :text             not null
#  image       :string
#  send_date   :datetime         not null
#  sender_name :string
#  title       :string           not null
#  token       :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  template_id :bigint
#  user_id     :bigint           not null
#
# Indexes
#
#  index_letters_on_template_id  (template_id)
#  index_letters_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (template_id => templates.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :letter do
    title { Faker::Name.name }
    body { Faker::Lorem.sentence }
    sender_name { Faker::Name.name }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test.jpg')) }
    send_date { Time.current + 1.hours }
    token { SecureRandom.hex(32) }
    user
  end
end
