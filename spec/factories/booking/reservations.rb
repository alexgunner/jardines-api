FactoryGirl.define do
	factory :reservation, class: Booking::Reservation do
		user { create :user }
		start_date { Faker::Date.between(1.day.from_now, 3.days.from_now) }
		end_date { Faker::Date.between(4.day.from_now, 7.days.from_now) }
		arrival_time { Faker::Number.between(0, 2400) }
		status { Booking::Reservation::PENDING }
		special_details { Faker::Lorem.paragraph }
		pin { Faker::Number.number(6) }
	end
end