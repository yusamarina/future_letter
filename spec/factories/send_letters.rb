FactoryBot.define do
  factory :send_letter do
    destination_id { 1 }
    letter { nil }
  end
end
