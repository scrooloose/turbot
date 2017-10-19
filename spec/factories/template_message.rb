FactoryGirl.define do
  factory :template_message do
    content 'I like horse riding too! ...'

    trait :biking do
      content 'I like biking as well ...'
      association :interest, :biking
    end

    association :user
    association :interest
  end
end
