module ReservationsHelper

	def non_user_reservation_params vars = {}
		params = logged_user_reservation_params vars
		params[:user] = vars[:user] || reservation_user
		return params
	end

	def logged_user_reservation_params vars = {}
		{
			rooms: vars[:rooms] || reservation_rooms(2),
			reservation: vars[:reservation] || reservation_info
		}
	end

	def reservation_user
		{
			email: Faker::Internet.email
		}
	end

	def reservation_rooms number
		rooms = []
		number.times do 
			room = create :room_with_price
			rooms << {
				id: room.id,
				guests: room.capacity.times.map { attributes_for(:guest, room_reservation: nil) }
			}
		end
		rooms
	end

	def reservation_info
		{
			arrival_time: 1200,
			start_date: 3.days.from_now,
			end_date: 5.days.from_now,
			special_details: Faker::Lorem.paragraph,
		}
	end

end