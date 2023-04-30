require 'date'
require 'factory_bot_rails'

FactoryBot.define do
  factory :admin_user, class: User do
    sequence(:name, 2) { |n| "admin#{n}" }
    sequence(:email, 2) { |n| "admin#{n}@example.com"}
    password { 'password' }
    password_confirmation { 'password' }
    admin { true }

    factory :admin_user_with_tasks do
      after(:create) do |user|
        create_list(:admin_task, 50, user: user)
      end
    end
  end

  factory :user, class: User do
    sequence(:name, 2) { |n| "user#{n}" }
    sequence(:email, 2) { |n| "user#{n}@example.com"}
    password { 'password' }
    password_confirmation { 'password' }
    admin { false }

    factory :user_with_tasks do
      after(:create) do |user|
        create_list(:task, 50, user: user)
      end
    end
  end
end