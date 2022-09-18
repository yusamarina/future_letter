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
require 'rails_helper'

RSpec.describe Anniversary, type: :model do
  describe 'バリデーション確認' do
    context '記念日名が未入力だった場合' do
      it '記念日の作成が出来ないこと' do
        blank_name_anniversary = Anniversary.new(date: Time.current)
        expect(blank_name_anniversary.valid?).to be false
        expect(blank_name_anniversary.errors[:name]).to include('を入力してください')
      end
    end

    context '記念日名が51文字以上の場合' do
      it '記念日の作成が出来ないこと' do
        long_name_anniversary = Anniversary.new(date: Time.current, name: Faker::Lorem.words(number: 51))
        expect(long_name_anniversary.valid?).to be false
        expect(long_name_anniversary.errors[:name]).to include('は50文字以内で入力してください')
      end
    end

    context '記念日の説明が151文字以上だった場合' do
      it '記念日の作成が出来ないこと' do
        long_description_anniversary = Anniversary.new(date: Time.current, name: Faker::Lorem.word, description: Faker::Lorem.sentence(word_count: 151))
        expect(long_description_anniversary.valid?).to be false
        expect(long_description_anniversary.errors[:description]).to include('は150文字以内で入力してください')
      end
    end
  end
end
