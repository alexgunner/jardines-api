FactoryGirl.define do
	factory :user_role do
		user { create :user }
		role { create :role }
	end
end