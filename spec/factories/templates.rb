# == Schema Information
#
# Table name: templates
#
#  id         :bigint           not null, primary key
#  content    :string           not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :template do
    name { "MyString" }
    content { "MyString" }
  end
end
