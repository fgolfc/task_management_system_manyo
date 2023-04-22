require 'rails_helper'

RSpec.describe 'ラベル管理機能', type: :system do
  before do
    # ログインする
    user = FactoryBot.create(:user, name: 'user0', email: 'user0@example.com', password: 'password', password_confirmation: 'password', admin: false)
    visit new_session_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログイン'
  end

  describe '登録機能' do
    context 'ラベルを登録した場合' do
      it '登録したラベルが表示される' do
        visit new_label_path
        fill_in 'ラベル名', with: 'テストラベル'
        click_button '登録する'
        expect(current_path).to eq labels_path
        expect(page).to have_content 'テストラベル'
      end
    end
  end
  
  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '登録済みのラベル一覧が表示される' do
        # 3つのラベルを作成する
        create(:label, name: 'ラベル1')
        create(:label, name: 'ラベル2')
        create(:label, name: 'ラベル3')
        
        # ラベル一覧ページにアクセスする
        visit labels_path
        
        # 登録済みのラベル一覧が表示されていることを確認する
        expect(page).to have_content 'ラベル1'
        expect(page).to have_content 'ラベル2'
        expect(page).to have_content 'ラベル3'
      end
    end
  end
end