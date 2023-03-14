# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'date'

date = Date.new(2025, 2, 18)

50.times do |n|
  created_at = date -= 1
  task = FactoryBot.create(:task, title: "#{n}#{n.ordinal}_task", created_at: created_at)
end