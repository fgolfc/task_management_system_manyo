# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'date'
require 'faker'

admin_user2 = User.create!(
  name: 'admin2',
  email: 'admin2@example.com',
  password: 'password',
  password_confirmation: 'password',
  admin: true
)

admin_user3 = User.create!(
  name: 'admin3',
  email: 'admin3@example.com',
  password: 'password',
  password_confirmation: 'password',
  admin: true
)

user2 = User.create!(
  name: 'user2',
  email: 'user2@example.com',
  password: 'password',
  password_confirmation: 'password',
  admin: false
)

user3 = User.create!(
  name: 'user3',
  email: 'user3@example.com',
  password: 'password',
  password_confirmation: 'password',
  admin: false
)

[admin_user2, admin_user3, user2, user3].each do |user|
  100.times do |n|
    Label.create!(
      name: "#{n+1}_label",
      user: user
    )
  end
end

[admin_user2, admin_user3].each do |user|
  50.times do |n|
    task = Task.create!(
      title: "#{n+1}_task",
      content: "Sample Content",
      deadline_on: Date.today + rand(1..30).days,
      priority: Task.priorities.keys.sample,
      status: Task.statuses.keys.sample,
      user: user
    )
    task.labels << Label.where(user_id: task.user_id).sample(3)
  end
end

[user2, user3].each do |user|
  50.times do |n|
    task = Task.create!(
      title: "#{n+1}_task",
      content: "Sample Content",
      deadline_on: Date.today + rand(1..30).days,
      priority: Task.priorities.keys.sample,
      status: Task.statuses.keys.sample,
      user: user
    )
    task.labels << Label.where(user_id: task.user_id).sample(3)
  end
end
