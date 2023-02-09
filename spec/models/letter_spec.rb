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
require 'rails_helper'

RSpec.describe Letter, type: :model do
  describe 'バリデーション確認' do
    context '手紙の宛名が未入力だった場合' do
      it '手紙の作成が出来ないこと' do
        blank_title_letter = Letter.new(body: Faker::Lorem.sentence, send_date: Time.current)
        expect(blank_title_letter.valid?).to be false
        expect(blank_title_letter.errors[:title]).to include('を入力してください')
      end
    end

    context '手紙の本文が未入力だった場合' do
      it '手紙の作成が出来ないこと' do
        blank_body_letter = Letter.new(title: Faker::Name.name, send_date: Time.current)
        expect(blank_body_letter.valid?).to be false
        expect(blank_body_letter.errors[:body]).to include('を入力してください')
      end
    end

    context '手紙の宛名が31文字以上の場合' do
      it '手紙の作成が出来ないこと' do
        long_title_letter = Letter.new(title: Faker::Lorem.words(number: 31), body: Faker::Lorem.sentence, send_date: Time.current)
        expect(long_title_letter.valid?).to be false
        expect(long_title_letter.errors[:title]).to include('は30文字以内で入力してください')
      end
    end

    context '手紙の本文が1001文字以上の場合' do
      it '手紙の作成が出来ないこと' do
        long_body_letter = Letter.new(title: Faker::Name.name, body: Faker::Lorem.sentence(word_count: 1001), send_date: Time.current)
        expect(long_body_letter.valid?).to be false
        expect(long_body_letter.errors[:body]).to include('は1000文字以内で入力してください')
      end
    end

    context '手紙の送信者名が31文字以上の場合' do
      it '手紙の作成が出来ないこと' do
        long_sender_name_letter = Letter.new(title: Faker::Name.name, body: Faker::Lorem.sentence, send_date: Time.current, sender_name: Faker::Lorem.words(number: 31))
        expect(long_sender_name_letter.valid?).to be false
        expect(long_sender_name_letter.errors[:sender_name]).to include('は30文字以内で入力してください')
      end
    end

    context '手紙の送信日時に過去の時刻を設定した場合' do
      it '手紙の作成が出来ないこと' do
        past_send_date_letter = Letter.new(title: Faker::Name.name, body: Faker::Lorem.sentence, send_date: Time.current - 1.minutes)
        expect(past_send_date_letter.valid?).to be false
        expect(past_send_date_letter.errors[:send_date]).to include('は未来の時間を選択してください')
      end
    end
  end
end
