FactoryBot.define do
  factory :letter do
    user { nil }
    template { nil }
    title { "MyString" }
    body { "MyText" }
    image { "MyString" }
  end
end
