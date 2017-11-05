FactoryGirl.define do
	factory :invoice, class: Booking::Invoice do
		resevation { create :reservation }
		total { Faker::Number.between(100, 1000) }
		status { Invoice::PENDING }
	end
end