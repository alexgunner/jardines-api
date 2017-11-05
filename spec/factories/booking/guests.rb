FactoryGirl.define do
	factory :guest, class: Booking::Guest do
		name { Faker::DragonBall.character }
		id_number { Faker::Number.number(10) }
		email { Faker::Internet.email }
		nationality { Faker::Science.element }
		room_reservation { build :room_reservation }
	end
end