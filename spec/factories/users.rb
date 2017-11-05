FactoryGirl.define do
	factory :user do
		expanse_id { Faker::Number.number(10) }
	end
end