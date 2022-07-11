FactoryBot.define do
  factory :letter_sending_date do
    destination_id { 1 }
    letter { nil }
    send_date { "2022-07-11 17:49:18" }
  end
end
