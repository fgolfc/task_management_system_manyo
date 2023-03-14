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

50.times do |n|
  next if n.zero?
  created_at = date -= 1
  title = "#{ActiveSupport::Inflector.ordinalize(n)}_task"
  task = FactoryBot.create(:task, title: title, created_at: created_at)
end