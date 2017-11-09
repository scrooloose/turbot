FactoryGirl.define do
  factory :user do
    sequence :pof_username do |n|
      "pof_user_#{n}"
    end
    pof_password "foobar"
    name "Rambo"
    association :profile

    sequence :email do |n|
      "email_#{n}@example.com"
    end
    password "foobar"
  end
end
