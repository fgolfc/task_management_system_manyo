require 'date'
require 'factory_bot_rails'

FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "#{n}_task" }
    content { "Sample Content" }
    deadline_on { Date.today + rand(1..30).days }
    priority { Task.priorities.keys.sample }
    status { Task.statuses.keys.sample }
    association :user

    factory :admin_task do
      association :user, factory: :admin_user
    end

    factory :general_task do
      association :user, factory: :general_user
    end
  end
end