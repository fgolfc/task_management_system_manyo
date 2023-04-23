FactoryBot.define do
  factory :label do
    sequence(:name) { |n| "#{n}_label" }
    association :user
    factory :labeled_task do
      after(:create) do |label|
        label.tasks << FactoryBot.create(:task)
      end
    end
  end
end