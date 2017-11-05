FactoryGirl.define do
	factory :room, class: Booking::Room do
		description { Faker::Lorem.paragraph }
		name { Faker::Lorem.word }
		capacity { [2, 4].sample }
	end

	factory :room_with_price, class: Booking::Room do
		description { Faker::Lorem.paragraph }
		name { Faker::Lorem.word }
		capacity { [2, 4].sample }

		after(:create) do |r|
			create :price, room_id: r.id, status: Booking::Price::CURRENT
		end
	end
end