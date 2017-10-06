FactoryGirl.define do
  factory :message do
    content "message content"
    sent_at Time.zone.now
    association :sender_profile, factory: :profile
    association :recipient_profile, factory: :profile
  end
end
