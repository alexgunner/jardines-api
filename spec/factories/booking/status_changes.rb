FactoryGirl.define do
	factory :status_change, class: Booking::StatusChange do
		old_status { Faker::Number.between(1000000, 1500000) }
		new_status { Faker::Number.between(1000000, 1500000) }
		object { create :reservation }
	end
end

