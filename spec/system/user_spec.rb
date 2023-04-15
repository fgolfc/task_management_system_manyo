require 'rails_helper'

RSpec.describe 'ユーザ管理機能', type: :system do
  describe '登録機能' do
    context 'ユーザを登録した場合' do
      it 'タスク一覧画面に遷移する' do
        visit create_user_path
        fill_in '名前', with: 'テストユーザー'
        fill_in 'メールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード（確認）', with: 'password'
        click_button '登録する'
        sleep(1)
        expect(current_path).to eq tasks_path
      end
    end

    context 'ログインせずにタスク一覧画面に遷移した場合' do
      it 'ログイン画面に遷移し、「ログインしてください」というメッセージが表示される' do
        visit tasks_path
        expect(current_path).to eq new_session_path
        expect(page).to have_content 'ログインしてください'
      end
    end
  end

  describe 'ログイン機能' do
    before do
      @user = FactoryBot.create(:user)
    end

    context '登録済みのユーザでログインした場合' do
      it 'タスク一覧画面に遷移し、「ログインしました」というメッセージが表示される' do
        visit new_session_path
        fill_in 'メールアドレス', with: @user.email
        fill_in 'パスワード', with: 'password'
        click_button 'ログイン'
        expect(current_path).to eq tasks_path
        expect(page).to have_content 'ログインしました'
      end
    end
  end

  describe '管理者機能' do
    before do
      @admin_user = FactoryBot.create(:user, name: 'admin', email: 'admin@example.com', password: 'password', password_confirmation: 'password', admin: true)
      @user = FactoryBot.create(:user)
      visit new_session_path
      fill_in 'メールアドレス', with: 'admin@example.com'
      fill_in 'パスワード', with: 'password'
      click_button 'ログイン'
    end
  
    context '管理者がログインした場合' do
      it 'ユーザ一覧画面にアクセスできる' do
        visit admin_users_path
        expect(current_path).to eq admin_users_path
      end
  
      it '管理者を登録できる' do
        visit new_admin_user_path
        fill_in '名前', with: 'テスト管理者'
        fill_in 'メールアドレス', with: 'admin2@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード（確認）', with: 'password'
        check '管理者権限'
        click_button '登録する'
        expect(page).to have_content 'ユーザを登録しました'
        visit admin_users_path
        expect(page).to have_content 'テスト管理者'
      end
  
      it 'ユーザ詳細画面にアクセスできる' do
        visit admin_user_path(@user)
        expect(current_path).to eq admin_user_path(@user)
      end
  
      it 'パスワードなしでも編集できる' do
        other_user = FactoryBot.create(:user)
        visit edit_admin_user_path(other_user)
        expect(current_path).to eq edit_admin_user_path(other_user)
        fill_in '名前', with: '編集後の名前'
        click_button '更新する'
        sleep(1)
        expect(current_path).to eq admin_users_path
        expect(page).to have_content 'ユーザを更新しました'
      end
  
      it 'ユーザを削除できる' do
        other_user = FactoryBot.create(:user)
        visit admin_users_path
        click_link '削除', href: admin_user_path(other_user)
        page.accept_confirm
        expect(current_path).to eq admin_users_path
        expect(page).to have_content 'ユーザを削除しました'
      end
    end

    context '一般ユーザがユーザ一覧画面にアクセスした場合' do
      before do
        @user = FactoryBot.create(:user, name: 'admin', email: 'admin0@example.com', password: 'password', password_confirmation: 'password', admin: false)
        visit new_session_path
        fill_in 'メールアドレス', with: 'admin0@example.com'
        fill_in 'パスワード', with: 'password'
        click_button 'ログイン'
      end
    
      it 'タスク一覧画面に遷移し、「管理者以外アクセスできません」というエラーメッセージが表示される' do
        visit admin_users_path
        expect(current_path).to eq tasks_path
        expect(page).to have_content '管理者以外アクセスできません'
      end
    end
  end
end