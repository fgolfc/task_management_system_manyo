# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'date'
require 'factory_bot_rails'

date = Date.new(2025, 2, 18)

require 'date'
require 'factory_bot_rails'

start_date = Date.new(2025, 2, 18)

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
  task = FactoryBot.create(:task, title: title, created_at: created_at, deadline_on: created_at + 7.days, priority: priority, status: status, content: 'Sample content')
end