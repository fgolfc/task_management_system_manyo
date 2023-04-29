require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  let!(:task1) { FactoryBot.create(:task, title: 'first_task', deadline_on: Date.new(2025, 02, 18), priority: :medium, status: :todo, user: user) }
  let!(:task2) { FactoryBot.create(:task, title: 'second_task', deadline_on: Date.new(2025, 02, 17), priority: :high, status: :doing, user: user) }
  let!(:task3) { FactoryBot.create(:task, title: 'third_task', deadline_on: Date.new(2025, 02, 16), priority: :low, status: :done, user: user) }

  describe '登録機能' do
    context 'タスクを登録した場合' do
      let!(:user) { FactoryBot.create(:user) }
      before do
        visit new_session_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: user.password
        click_button 'ログイン'
        visit new_task_path
        fill_in 'タイトル', with: 'first_task'
        fill_in '内容', with: '企画書を作成する。'
        fill_in'task_deadline_on', with: Date.new(2025, 02, 25)
        select('低', from: 'task_priority')
        select('完了', from: 'task_status')
        click_button '登録する'
      end

      it '登録したタスクが表示される' do
        expect(page).to have_content('first_task')
      end
    end
  end

  describe '一覧表示機能' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:task1) { FactoryBot.create(:task, user: user, title: 'task1', created_at: 3.days.ago) }
    let!(:task2) { FactoryBot.create(:task, user: user, title: 'task2', created_at: 2.days.ago) }
    let!(:task3) { FactoryBot.create(:task, user: user, title: 'task3', created_at: 1.day.ago) }
  
    before do
      visit new_session_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'
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
      let!(:new_task) { FactoryBot.create(:task, title: 'new_task_title', deadline_on: Date.new(2025, 02, 16), priority: :medium, status: :todo, user: user) }
  
      it '新しいタスクが一番上に表示される' do
        visit tasks_path
        expect(page).to have_content new_task.title
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content new_task.title
      end
    end
  end

  describe 'ソート機能' do
    let!(:user) { FactoryBot.create(:user) }
    before do
      visit new_session_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'
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
    let!(:user) { FactoryBot.create(:user) }
    let!(:label_1) { FactoryBot.create(:label, name: 'label_1', user: user) }
    let!(:label_2) { FactoryBot.create(:label, name: 'label_2', user: user) }
    let!(:label_3) { FactoryBot.create(:label, name: 'label_3', user: user) }
    let!(:label_4) { FactoryBot.create(:label, name: 'label_4', user: user) }
    let!(:label_5) { FactoryBot.create(:label, name: 'label_5', user: user) }

    let!(:task1) { FactoryBot.create(:task, user: user, title: 'first_task', created_at: 3.days.ago, status: :todo, label_ids: [label_1.id, label_2.id]) }
    let!(:task2) { FactoryBot.create(:task, user: user, title: 'second_task', created_at: 2.days.ago, status: :doing, label_ids: [label_2.id, label_3.id]) }
    let!(:task3) { FactoryBot.create(:task, user: user, title: 'third_task', created_at: 1.day.ago, status: :done, label_ids: [label_3.id, label_4.id]) }
    let!(:task4) { FactoryBot.create(:task, user: user, title: 'forth_task', deadline_on: Date.new(2025, 02, 18), priority: :low, status: :done, label_ids: [label_4.id, label_5.id]) }
  
    before do
      visit new_session_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'
    end
  
    describe 'タイトルであいまい検索をした場合' do
      before do
        visit tasks_path
        fill_in 'search_title', with: 'd_task'
        click_button('search_task')
      end
  
      it "検索ワードを含むタスクのみ表示される" do
        expect(page).to have_content(task2.title)
        expect(page).to have_content(task3.title)
        expect(page).not_to have_content(task1.title)
        expect(page).not_to have_content(task4.title)
      end
    end
  
    describe 'ステータスで検索した場合' do
      before do
        visit tasks_path
        fill_in 'search_title', with: ''
        select('完了', from: 'task_status')
        click_button('search_task')
      end
  
      it "検索したステータスに一致するタスクのみ表示される" do
        expect(page).not_to have_content(task1.title)
        expect(page).not_to have_content(task2.title)
        expect(page).to have_content(task3.title)
        expect(page).to have_content(task4.title)
      end
    end
  
    describe 'タイトルとステータスで検索した場合' do
      before do
        visit tasks_path
        select('完了', from: 'task_status')
        fill_in 'search_title', with: 'd_task'
        click_button('search_task')
      end
  
      it "検索ワードをタイトルに含み、かつステータスに一致するタスクのみ表示される" do
        expect(page).not_to have_content(task1.title)
        expect(page).not_to have_content(task2.title)
        expect(page).to have_content(task3.title)
        expect(page).not_to have_content(task4.title)
      end
    end

    describe 'ラベルで検索をした場合' do
      before do
        select('label_2', from: 'label_ids')
        click_button('search_task')
      end
    
      it "そのラベルの付いたタスクがすべて表示される" do
        expect(page).to have_content(task1.title)
        expect(page).to have_content(task2.title)
        expect(page).not_to have_content(task3.title)
        expect(page).not_to have_content(task4.title)
      end
    end
  end
  
  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
      let!(:user) { FactoryBot.create(:user) }
      before do
        visit new_session_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: user.password
        click_button 'ログイン'
        FactoryBot.create(:task, deadline_on: Date.new(2025, 02, 16), priority: :medium, status: :todo, user: user)
        visit tasks_path
        click_on 'search_task'
      end

      it 'そのタスクの内容が表示される' do
        expect(page).to have_content 'first_task'
      end
    end
  end
end