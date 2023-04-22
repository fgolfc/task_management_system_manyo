FactoryBot.define do
  factory :label do
    name { "MyString" }

    factory :labeled_task do
      after(:create) do |label|
        label.tasks << FactoryBot.create(:task)
      end
    end
  end
end