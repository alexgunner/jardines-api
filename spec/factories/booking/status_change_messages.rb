FactoryGirl.define do
	factory :status_change_message, class: Booking::StatusChangeMessage do
		status_change { create :status_change }
		body { Faker::Lorem.paragraph }
	end
end