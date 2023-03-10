FactoryBot.define do
  factory :task do
    title { '書類作成' }
    content { '企画書を作成する。' }
  end
  factory :second_task, class: Task do
    title { 'メール送信' }
    content { '顧客へ営業のメールを送る。' }
  end
end
