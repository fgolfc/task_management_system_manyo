require 'factory_bot_rails'

FactoryBot.define do
  factory :task_label do
    task
    label
  end
end