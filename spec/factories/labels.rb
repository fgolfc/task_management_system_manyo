require 'factory_bot_rails'

FactoryBot.define do
  factory :label do
    sequence(:name, (1..50).cycle) { |n| "#{n}_label" }
    association :user

    factory :labeled_task do
      after(:create) do |label|
        FactoryBot.create(:task, label_ids: [label.id])
      end
    end
  end
end
