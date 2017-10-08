FactoryGirl.define do
  factory :admin_user do
    sequence(:email) do |n|
      "admin-#{n}@example.com"
    end

    password "foobar"
  end
end
