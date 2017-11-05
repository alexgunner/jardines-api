FactoryGirl.define do
	factory :price, class: Booking::Price do
		one_guest { Faker::Number.between(1, 100) }
		two_guests { Faker::Number.between(1, 100) }
		room { build :room }
		status { Booking::Price::OLD }
	end
end
