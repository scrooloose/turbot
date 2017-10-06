FactoryGirl.define do
  factory :topic do
    sequence :name do |n|
      "topic #{n}"
    end

    matchers 'horse riding'
    message 'I like horse riding too! ...'

    trait :likes_biking do
      matchers 'biking'
      message 'I like biking as well ...'
    end
  end
end
