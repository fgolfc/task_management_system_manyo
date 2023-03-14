require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  describe '登録機能' do
    context 'タスクを登録した場合' do
      before do
        visit new_task_path
        fill_in 'タイトル', with: 'first_task'
        fill_in '内容', with: '企画書を作成する。'
        click_button '登録する'
      end

      it '登録したタスクが表示される' do
        expect(page).to have_content('first_task')
      end
    end
  end

  describe '一覧表示機能' do
    # let!を使ってテストデータを変数として定義することで、複数のテストでテストデータを共有できる
    let!(:task1) { FactoryBot.create(:task, created_at: '2025-02-18') }
    let!(:task2) { FactoryBot.create(:task, created_at: '2025-02-17') }
    let!(:task3) { FactoryBot.create(:task, created_at: '2025-02-16') }
  
    # 「一覧画面に遷移した場合」や「タスクが作成日時の降順に並んでいる場合」など、contextが実行されるタイミングで、before内のコードが実行される
    before do
      visit tasks_path
    end
  
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が作成日時の降順で表示される' do
        task_list = all('tbody tr')
  
        expect(task_list[0]).to have_content task1.title
        expect(task_list[1]).to have_content task2.title
        expect(task_list[2]).to have_content task3.title
      end
    end

    context '新たにタスクを作成した場合' do
      let!(:new_task) { FactoryBot.create(:task, title: 'new_task_title') }

      before do
        visit tasks_path
      end

      it '新しいタスクが一番上に表示される' do
        travel_to Date.new(2025, 02, 20)
        expect(page).to have_content('new_task_title')
        expect(page).to have_content(new_task.created_at.strftime('%Y/%m/%d'))
      end
    end
  end

  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
      before do
        FactoryBot.create(:task)
        visit tasks_path
        click_on '詳細'
      end

      it 'そのタスクの内容が表示される' do
        expect(page).to have_content 'first_task'
      end
    end
  end
end