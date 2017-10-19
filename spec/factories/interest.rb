FactoryGirl.define do
  factory :interest do
    sequence :name do |n|
      "interest #{n}"
    end

    matchers 'horse riding'

    trait :biking do
      matchers 'biking'
    end
  end
end
