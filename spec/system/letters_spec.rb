require 'rails_helper'

RSpec.describe "Letters", js: true, type: :system do
  let!(:user) { create(:user) }
  let!(:letter) { create(:letter, user: user) }
  let(:another_user){ create(:user) }
  let(:another_letter) { create(:letter, user: another_user) }

  before do
    allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: user.id)
    visit letters_path
  end

  describe '下書きの手紙一覧' do
    it '自分が下書き保存した手紙が表示されること' do
      expect(page).to have_content letter.send_date.strftime("%Y-%m-%d %H:%M")
      expect(page).to have_content letter.title
      expect(current_path).to eq letters_path
    end

    it '他のユーザーの手紙は表示されないこと' do
      expect(page).not_to have_content another_letter.title
      expect(page).not_to have_content another_letter.body
      expect(current_path).to eq letters_path
    end

    context '下書き中の手紙の削除ボタンを押した場合' do
      it '手紙が削除されること' do
        page.accept_confirm do
          click_link 'Destroy'
        end
        switch_to_window(windows.last)
        expect(page).not_to have_content letter.title
        expect(page).not_to have_content letter.body
        expect(current_path).to eq letters_path
      end
    end
  end

  describe '下書きの手紙編集' do
    context '下書き中の手紙編集ページを開いた場合' do
      it '手紙の編集ページが表示されること' do
        visit edit_letter_path(letter)
        expect(page).to have_content 'EDIT LETTER'
        expect(page).to have_field '手紙を送りたい相手の名前', with: letter.title
        expect(page).to have_field '手紙の本文', with: letter.body
        expect(current_path).to eq edit_letter_path(letter)
      end
    end

    context '他のユーザーの手紙編集ページを開いた場合' do
      before do
        driven_by(:rack_test)
      end

      it '404ページが表示されること' do
        visit edit_letter_path(another_letter)
        expect(page).not_to have_field '手紙を送りたい相手の名前', with: another_letter.title
        expect(page).not_to have_field '手紙の本文', with: another_letter.body
        expect(page.status_code).to eq(404)
      end
    end

    context '31文字以上の宛名を設定した場合' do
      it '手紙の宛名の更新が失敗すること' do
        visit edit_letter_path(letter)
        fill_in '手紙を送りたい相手の名前', with: Faker::Lorem.characters(number: 31)
        click_button '手紙を送る相手を選ぶ'
        expect(page).to have_content '手紙を送りたい相手の名前は30文字以内で入力してください'
        expect(current_path).to eq edit_letter_path(letter)
      end
    end

    context '1001文字以上の宛名を設定した場合' do
      it '手紙の宛名の更新が失敗すること' do
        visit edit_letter_path(letter)
        fill_in '手紙の本文', with: Faker::Lorem.sentence(word_count: 1001)
        click_button '手紙を送る相手を選ぶ'
        expect(page).to have_content '手紙の本文は1000文字以内で入力してください'
        expect(current_path).to eq edit_letter_path(letter)
      end
    end
  end
end
