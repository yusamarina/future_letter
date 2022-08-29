# == Schema Information
#
# Table name: send_letters
#
#  id             :bigint           not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  destination_id :integer          not null
#  letter_id      :bigint           not null
#
# Indexes
#
#  index_send_letters_on_destination_id  (destination_id)
#  index_send_letters_on_letter_id       (letter_id)
#
# Foreign Keys
#
#  fk_rails_...  (destination_id => users.id)
#  fk_rails_...  (letter_id => letters.id)
#
FactoryBot.define do
  factory :send_letter do
    destination_id { 1 }
    letter { nil }
  end
end
