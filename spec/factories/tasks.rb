FactoryBot.define do
  factory :task do
    title { 'first_task' }
    content { '企画書を作成する。' }
    created_at { 2025/02/18 }
  end
  factory :second_task, class: Task do
    title { 'second_task' }
    content { '顧客へ営業のメールを送る。' }
    created_at { 2025/02/17 }
  end
  factory :third_task, class: Task do
    title { 'third_task' }
    content { '顧客へ電話をする。' }
    created_at { 2025/02/16 }
  end
end
