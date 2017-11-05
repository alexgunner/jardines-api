FactoryGirl.define do
	factory :room_reservation, class: Booking::RoomReservation do
		reservation { build :reservation }
		price { build :price, status: Booking::Price::CURRENT }

		after(:build) do |rr| 
			rr.room = rr.price.room
		end
	end
end
