require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  let!(:task1) { FactoryBot.create(:task, title: 'first_task', deadline: Date.new(2025, 02, 18), priority: :medium, status: :todo) }
  let!(:task2) { FactoryBot.create(:task, title: 'second_task', deadline: Date.new(2025, 02, 17), priority: :high, status: :doing) }
  let!(:task3) { FactoryBot.create(:task, title: 'third_task', deadline: Date.new(2025, 02, 16), priority: :low, status: :done) }

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
    # 「一覧画面に遷移した場合」や「タスクが作成日時の降順に並んでいる場合」など、contextが実行されるタイミングで、before内のコードが実行される
    before do
      visit tasks_path
    end
  
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が作成日時の降順で表示される' do
        task_list = all('tbody tr')
  
        expect(task_list[0]).to have_content task3.title
        expect(task_list[1]).to have_content task2.title
        expect(task_list[2]).to have_content task1.title
      end
    end

    context '新たにタスクを作成した場合' do
      let!(:new_task) { FactoryBot.create(:task, title: 'new_task_title', deadline: Date.new(2025, 02, 16), priority: :medium, status: :todo) }
      
      it '新しいタスクが一番上に表示される' do
        expect(Task.all.order(created_at: :desc).first).to eq new_task
      end
    end
  end

  describe 'ソート機能' do
    before do
      visit tasks_path
    end

    context '「終了期限」というリンクをクリックした場合' do
      it "終了期限昇順に並び替えられたタスク一覧が表示される" do     
        click_on '終了期限'
        sleep(3)
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content task3.title
        expect(task_list[1]).to have_content task2.title
        expect(task_list[2]).to have_content task1.title
      end
    end
      
    context '「優先度」というリンクをクリックした場合' do
      it "優先度の高い順に並び替えられたタスク一覧が表示される" do
        click_on '優先度'
        sleep(3)
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content task2.title
        expect(task_list[1]).to have_content task1.title
        expect(task_list[2]).to have_content task3.title
      end
    end
  end
      
  describe '検索機能' do
    let!(:task4) { FactoryBot.create(:task, title: 'forth_task', deadline: Date.new(2025, 02, 15), priority: :low, status: :done) }
  
    before do
      visit tasks_path
    end
  
    describe 'タイトルであいまい検索をした場合' do
      before do
        fill_in 'search_title', with: 'd_task'
        click_button('search_task')
        sleep(7)
      end
  
      it "検索ワードを含むタスクのみ表示される" do
        expect(page).to have_content task2.title
        expect(page).to have_content task3.title
        expect(page).not_to have_content task1.title
        expect(page).not_to have_content task4.title
      end
    end
  
    describe 'ステータスで検索した場合' do
      before do
        select('完了', from: 'task_status')
        click_button('search_task')
        sleep(7)
      end
  
      it "検索したステータスに一致するタスクのみ表示される" do
        expect(page).to have_content task3.title
        expect(page).to have_content task4.title
        expect(page).not_to have_content task1.title
        expect(page).not_to have_content task2.title
      end
    end
  
    describe 'タイトルとステータスで検索した場合' do
      before do
        select('完了', from: 'task_status')
        fill_in 'search_title', with: 'd_task'
        click_button('search_task')
        sleep(7)
      end
  
      it "検索ワードをタイトルに含み、かつステータスに一致するタスクのみ表示される" do
        expect(page).to have_content task3.title
        expect(page).not_to have_content task1.title
        expect(page).not_to have_content task2.title
        expect(page).not_to have_content task4.title
      end
    end
  end
  
  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
      before do
        FactoryBot.create(:task, deadline: Date.new(2025, 02, 16), priority: :medium, status: :todo)
        visit tasks_path
        click_on 'search_task'
      end

      it 'そのタスクの内容が表示される' do
        expect(page).to have_content 'first_task'
      end
    end
  end
end