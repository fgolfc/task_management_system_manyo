# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'date'
require 'factory_bot_rails'

admin = FactoryBot.create(:admin_user_with_tasks)
user = FactoryBot.create(:user_with_tasks)

userTL = User.find_or_create_by(name: 'userTL', email: 'userTL@example.com', password_digest: 'password')

task = Task.create!(title: 'Task 1', content: 'Do something', deadline_on: Date.today, priority: :low, status: :todo, user: userTL)

label1 = Label.create!(name: 'Label 1', user: userTL )
label2 = Label.create!(name: 'Label 2', user: userTL )
task.labels << label1
task.labels << label2