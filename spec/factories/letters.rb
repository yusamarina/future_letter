FactoryBot.define do
  factory :letter do
    user { nil }
    template { nil }
    title { "MyString" }
    body { "MyText" }
    image { "MyString" }
    send_date { "2022-07-11 17:49:18" }
  end
end
