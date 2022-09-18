require 'rails_helper'

RSpec.describe "AdminPages", type: :system do
  let(:admin_user) { create(:user, :admin) }
  let(:general_user) { create(:user, :general) }

  describe '管理画面:adminユーザー' do
    before do
      allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: admin_user.id)
    end

    context '管理者権限を持つユーザーがログインしている場合' do
      it '管理画面へ遷移出来ること' do
        visit admin_root_path
        expect(page).to have_content 'DASHBOARD'
        expect(current_path).to eq admin_root_path
      end
    end

    context '管理者権限を持つユーザーがログアウトボタンを押した場合' do
      it 'ログアウトしトップページへ遷移すること' do
        visit admin_root_path
        page.accept_confirm do
          click_link 'LOG OUT'
        end
        switch_to_window(windows.last)
        expect(current_path).to eq top_path
      end
    end

    context '管理者権限を持つユーザーがログアウト後に管理画面を開いた場合' do
      it '管理画面へ遷移出来ず、トップページへ遷移すること' do
        visit admin_root_path
        page.accept_confirm do
          click_link 'LOG OUT'
        end
        visit admin_root_path
        expect(page).not_to have_content 'DASHBOARD'
        expect(current_path).to eq top_path
      end
    end
  end

  describe '管理画面:generalユーザー' do
    before do
      allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: general_user.id)
    end

    context 'generalユーザーが管理画面を開いた場合' do
      it '管理画面へ遷移出来ず、トップページへ遷移すること' do
        visit admin_root_path
        switch_to_window(windows.last)
        expect(page).not_to have_content 'DASHBOARD'
        expect(current_path).to eq top_path
      end
    end
  end
end
