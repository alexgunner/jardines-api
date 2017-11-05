FactoryGirl.define do
	factory :aggregated_user_datum do
		user { create :user }
		email { Faker::Internet.email }
	end
end