FactoryGirl.define do
  factory :post do
    title "MyString"
    body "MyText"
    creator_id 1
    post_type "MyString"
    approved false
  end
end
