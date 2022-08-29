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
class SendLetter < ApplicationRecord
  belongs_to :letter
  belongs_to :user, class_name: 'User', foreign_key: :destination_id

  validates :destination_id, presence: true
  validates :letter_id, presence: true
end
