FactoryGirl.define do
  factory :template_message do
    content 'I like horse riding too! ...'

    trait :biking do
      content 'I like biking as well ...'
      association :interest, :biking
    end

    trait :disabled do
      state TemplateMessage::STATE_DISABLED
    end

    association :user
    association :interest
  end
end
