require 'rails_helper'

RSpec.describe "Anniversaries", type: :system do
  let!(:user){ create(:user) }
  let!(:anniversary){ create(:anniversary, user: user) }
  let(:another_user){ create(:user) }
  let(:another_anniversary){ create(:anniversary, user: another_user) }

  before do
    allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: user.id)
    visit anniversaries_path
  end

  describe '記念日一覧' do
    it '自分が登録した記念日が表示されること' do
      expect(page).to have_content short_time(anniversary.date)
      expect(page).to have_content anniversary.name
      expect(current_path).to eq anniversaries_path
    end

    it '他のユーザーの記念日が表示されないこと' do
      expect(page).not_to have_content another_anniversary.date
      expect(page).not_to have_content another_anniversary.name
      expect(current_path).to eq anniversaries_path
    end

    context '自分の記念日の削除ボタンを押した場合' do
      it '記念日が削除されること' do
        page.accept_confirm do
          click_link 'Destroy'
        end
        switch_to_window(windows.last)
        expect(page).not_to have_content short_time(anniversary.date)
        expect(page).not_to have_content anniversary.name
        expect(current_path).to eq anniversaries_path
      end
    end
  end

  describe '記念日の編集' do
    context '記念日の編集ページを開いた場合' do
      it '記念日の編集ページへ遷移すること' do
        visit edit_anniversary_path(anniversary)
        expect(page).to have_content 'EDIT ANNIVERSARY'
        expect(page).to have_field '記念日名', with: anniversary.name
        expect(page).to have_field '説明', with: anniversary.description
        expect(current_path).to eq edit_anniversary_path(anniversary)
      end
    end

    context '記念日の日付をクリックした場合' do
      it '記念日の編集ページへ遷移すること' do
        click_link short_time(anniversary.date)
        switch_to_window(windows.last)
        expect(page).to have_content 'EDIT ANNIVERSARY'
        expect(page).to have_field '記念日名', with: anniversary.name
        expect(page).to have_field '説明', with: anniversary.description
        expect(current_path).to eq edit_anniversary_path(anniversary)
      end
    end

    context '記念日名をクリックした場合' do
      it '記念日の編集ページへ遷移すること' do
        click_link anniversary.name
        switch_to_window(windows.last)
        expect(page).to have_content 'EDIT ANNIVERSARY'
        expect(page).to have_field '記念日名', with: anniversary.name
        expect(page).to have_field '説明', with: anniversary.description
        expect(current_path).to eq edit_anniversary_path(anniversary)
      end
    end

    context '他のユーザーの記念日編集ページを開いた場合' do
      before do
        driven_by(:rack_test)
      end

      it '404ページが表示されること' do
        visit edit_anniversary_path(another_anniversary)
        expect(page).not_to have_field '記念日名', with: another_anniversary.name
        expect(page).not_to have_field '説明', with: another_anniversary.description
        expect(page.status_code).to eq(404)
      end
    end

    context '51文字以上の記念日名を設定した場合' do
      it '記念日名の更新が失敗すること' do
        visit edit_anniversary_path(anniversary)
        fill_in '記念日名', with: Faker::Lorem.characters(number: 51)
        click_button '保存する'
        expect(page).to have_content '記念日名は50文字以内で入力してください'
        expect(current_path).to eq edit_anniversary_path(anniversary)
      end
    end

    context '151文字以上の説明文を設定した場合' do
      it '記念日の説明文の更新が失敗すること' do
        visit edit_anniversary_path(anniversary)
        fill_in '説明', with: Faker::Lorem.sentence(word_count: 151)
        click_button '保存する'
        expect(page).to have_content '説明は150文字以内で入力してください'
        expect(current_path).to eq edit_anniversary_path(anniversary)
      end
    end
  end
end
