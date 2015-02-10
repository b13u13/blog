FactoryGirl.define do
  factory :user do
    name                  "Test Name"
    email                 "test@example.com"
    password              "password"
    password_confirmation "password"
  end
end