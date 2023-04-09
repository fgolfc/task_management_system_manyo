# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
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

  factory :admin_user, class: User do
    sequence(:name) { |n| "admin#{n}" }
    sequence(:email) { |n| "admin#{n}@example.com"}
    password { 'password' }
    password_confirmation { 'password' }
    admin { true }

    factory :admin_user_with_tasks do
      after(:create) do |user|
        create_list(:admin_task, 50, user: user)
      end
    end
  end

  factory :general_user, class: User do
    sequence(:name) { |n| "user#{n}" }
    sequence(:email) { |n| "user#{n}@example.com"}
    password { 'password' }
    password_confirmation { 'password' }
    admin { false }

    factory :general_user_with_tasks do
      after(:create) do |user|
        create_list(:general_task, 50, user: user)
      end
    end
  end
end

admin = FactoryBot.create(:admin_user_with_tasks)
general = FactoryBot.create(:general_user_with_tasks)