require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'バリデーションのテスト' do
    context 'タスクのタイトルが空文字の場合' do
      it 'バリデーションに失敗する' do
        task = Task.create(title: '', content: '企画書を作成する。', deadline: '2025/5/25', priority: 'medium', status: 'doing')
        expect(task).not_to be_valid
      end
    end

    context 'タスクの説明が空文字の場合' do
      it 'バリデーションに失敗する' do
        task = Task.create(title: '書類作成', content: '', deadline: '2025/5/25', priority: 'medium', status: 'doing')
        expect(task).not_to be_valid
      end
    end

    context 'タスクのタイトルと説明に値が入っている場合' do
      it 'タスクを登録できる' do
        task = Task.create(title: '書類作成', content: '企画書を作成する。', deadline: '2025/5/25', priority: 'medium', status: 'doing')
        expect(task).to be_valid
      end
    end
  end

  describe '検索機能' do
    let!(:first_task) { FactoryBot.create(:task, title: 'first_write_task', deadline: '2025/5/25', priority: 'medium', status: 'todo')  }
    let!(:second_task) { FactoryBot.create(:second_task, title: "first_call_task", deadline: '2025/5/25', priority: 'medium', status: 'doing') }
    let!(:third_task) { FactoryBot.create(:third_task, title: "second_write_task", deadline: '2025/5/25', priority: 'medium', status: 'todo') }
  
    context 'scopeメソッドでタイトルのあいまい検索をした場合' do
      it "検索ワードを含むタスクが絞り込まれる" do
        # 検索されたものとされなかったものの両方を確認する
        expect(Task.search_by_title('first')).to include(first_task)
        expect(Task.search_by_title('first')).to include(second_task)
        expect(Task.search_by_title('first')).not_to include(third_task)
        # 検索されたテストデータの数を確認する
        expect(Task.search_by_title('first').count).to eq 2
      end
    end
  
    context 'scopeメソッドでステータス検索をした場合' do
      it "ステータスに完全一致するタスクが絞り込まれる" do
        # 検索されたものとされなかったものの両方を確認する
        expect(Task.filter_by_status('todo')).to include(first_task)
        expect(Task.filter_by_status('todo')).not_to include(second_task)
        expect(Task.filter_by_status('todo')).to include(third_task)
        # 検索されたテストデータの数を確認する
        expect(Task.filter_by_status('todo').count).to eq 2
      end
    end
      
    context 'scopeメソッドでタイトルのあいまい検索とステータス検索をした場合' do
      it "検索ワードをタイトルに含み、かつステータスに完全一致するタスクが絞り込まれる" do
        # 検索されたものとされなかったものの両方を確認する
        expect(Task.search_by_title('first').filter_by_status('todo')).to include(first_task)
        expect(Task.search_by_title('first').filter_by_status('todo')).not_to include(second_task)
        expect(Task.search_by_title('first').filter_by_status('todo')).not_to include(third_task)
        # 検索されたテストデータの数を確認する
        expect(Task.search_by_title('first').filter_by_status('todo').count).to eq 1
      end
    end
  end
end
