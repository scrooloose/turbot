FactoryGirl.define do
  factory :interest do
    sequence :name do |n|
      "interest #{n}"
    end

    matchers 'horse riding'

    trait :biking do
      name 'Biking'
      matchers 'biking'
    end

    trait :running do
      name 'Running'
      matchers 'running'
    end

    trait :cooking do
      name 'Cooking'
      matchers 'cooking'
    end
  end
end
