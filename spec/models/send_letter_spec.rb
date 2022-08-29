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
require 'rails_helper'

RSpec.describe SendLetter, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
