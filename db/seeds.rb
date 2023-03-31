# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'date'
require 'factory_bot_rails'

start_date = Date.new(2025, 2, 18)

FactoryBot.define do
  factory :my_task do
    title { "Sample Title" }
    content { "Sample Content" }
    deadline_on { Date.today + 7.days }
    status { :todo }
    priority { :low }
    user_id { 1 }
  end
end

(1..10).each do |n|
  random_offset = rand(30) # generate a random number between 0 and 29
  created_at = start_date - random_offset
  suffix = case n % 10
    when 1 then "st"
    when 2 then "nd"
    when 3 then "rd"
    else "th"
  end
  title = "#{n}#{suffix}_task"
  priority = Task.priorities.keys.sample
  status = Task.statuses.keys.sample
  task = FactoryBot.create(:my_task, title: title, created_at: created_at, deadline_on: created_at + 7.days, priority: priority, status: status)
end

# 管理者を作成する
User.create!(name: 'admin', email: 'admin@example.com', password: 'password', password_confirmation: 'password', admin: true)

# その他のユーザーを作成する
User.create!(name: 'Alice', email: 'alice@example.com', password: 'password', password_confirmation: 'password')
User.create!(name: 'Bob', email: 'bob@example.com', password: 'password', password_confirmation: 'password')