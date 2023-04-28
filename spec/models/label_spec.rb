require 'rails_helper'

RSpec.describe 'ラベルモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    let(:user) { create(:user) }
    let(:label) { build(:label, user: user) }

    context 'ラベルの名前が空文字の場合' do
      it 'バリデーションに失敗する' do
        label.name = ''
        expect(label).not_to be_valid
      end
    end

    context 'ラベルの名前に値があった場合' do
      it 'バリデーションに成功する' do
        expect(label).to be_valid
      end
    end
  end
end