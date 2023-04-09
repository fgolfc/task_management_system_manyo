require 'rails_helper'

RSpec.describe 'ユーザモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    before do
      @user = FactoryBot.create(:user)
    end

    context 'ユーザの名前が空文字の場合' do
      it 'バリデーションに失敗する' do
        @user.name = ''
        expect(@user.valid?).to eq(false)
      end
    end

    context 'ユーザのメールアドレスが空文字の場合' do
      it 'バリデーションに失敗する' do
        @user.email = ''
        expect(@user.valid?).to eq(false)
      end
    end

    context 'ユーザのパスワードが空文字の場合' do
      it 'バリデーションに失敗する' do
        @user.password = ''
        @user.password_confirmation = '' 
        expect(@user.valid?).to eq(false)
      end
    end

    context 'ユーザのメールアドレスがすでに使用されていた場合' do
      it 'バリデーションに失敗する' do
        user2 = FactoryBot.build(:user, email: @user.email)
        expect(user2.valid?).to eq(false)
      end
    end

    context 'ユーザのパスワードが6文字未満の場合' do
      it 'バリデーションに失敗する' do
        @user.password = '12345'
        expect(@user.valid?).to eq(false)
      end
    end

    context 'ユーザの名前に値があり、メールアドレスが使われていない値で、かつパスワードが6文字以上の場合' do
      it 'バリデーションに成功する' do
        user2 = FactoryBot.build(:user)
        expect(user2.valid?).to eq(true)
      end
    end
  end
end