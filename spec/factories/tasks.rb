require 'date'
require 'factory_bot_rails'

FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "#{n}_task" }
    content { "Sample Content" }
    deadline_on { Date.today + rand(1..30).days }
    priority { Task.priorities.keys.sample }
    status { Task.statuses.keys.sample }

    transient do
      label_ids { nil }
    end

    after(:create) do |task, evaluator|
      if evaluator.label_ids.blank?
        labels = FactoryBot.create_list(:label, 3)
        task.labels << labels
      else
        task.labels << evaluator.label_ids.map { |id| Label.find(id) }
      end
    end

    factory :admin_task do
      association :user, factory: :admin_user_with_tasks
    end

    factory :general_task do
      association :user, factory: :user_with_tasks
    end
  end
end