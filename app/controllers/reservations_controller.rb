class ReservationsController < ApplicationController

	check_role Security::Roles::Client.uid, on: :history

	def create

		reservation = Booking::Reservation.new(reservation_params)

		Booking::Reservation.transaction do

			raise Exceptions::Booking::NoRoomDataFound if params[:rooms].nil? or params[:rooms].empty?

			reservation.user = reservation_user
			reservation.save!

			params[:rooms].each do |room_datum|
				room = Booking::Room.find room_datum[:id]
				room_guests = filter room_datum[:guests]
				raise Exceptions::Booking::NoGuestFound if room_guests.nil? or room_guests.size == 0 
	
				reservation.add_room! room

				room_guests.each do |guest_datum|
					reservation.add_guest_with_data! guest_datum, to: room
				end
			end
		end

		render json:[], status: :created
	end
	
	def update
		reservation_id = params[:reservation_id]
		reservation = Booking::Reservation.find(reservation_id)
		
		Booking::Reservation.transaction do

			raise Exceptions::Booking::NoRoomDataFound if params[:rooms].nil? or params[:rooms].empty?

			reservation.user = reservation_user
			reservation.save!

			params[:rooms].each do |room_datum|
				room = Booking::Room.find room_datum[:id]
				room_guests = filter room_datum[:guests]
				raise Exceptions::Booking::NoGuestFound if room_guests.nil? or room_guests.size == 0 
	
				reservation.add_room! room

				room_guests.each do |guest_datum|
					reservation.add_guest_with_data! guest_datum, to: room
				end
			end
		end

		render json:[], status: "updated"
	end

	def cancel
		reservation_pin = params[:pin]
		reservation_email = params[:email]
		cancellation_reason = params[:reason]
		
		if not current_user.nil?
			@reservation = Booking::Reservation.find_by(reservation_pin)
			@reservation.cancel cancellation_reason
			render json:[], status: "Cancelled"
		end
		
	end

	def show
		reservation_pin = params[:pin]
		reservation_email = params[:email]

		@reservation = Booking::Reservation.find_by(reservation_pin)


		if reservation_email.nil?
			if @reservation.nil? 
				render json: '{ response: "No reservation found", status: 404 }'
			else
				render json: @reservation
			end
		else
			if @reservation.nil? 
				render json: '{ response: "No reservation found", status: 404 }'
			else
				render json: @reservation
			end
		end

	end

	def update
		reservation_pin = params[:pin]

		@reservation = Booking::Reservation.find_by(reservation_pin)

		@reservation.update()
	end

	def history
		render json: current_user.reservations, each_serializer: Booking::ReservationSerializer, status: :ok
	end

	private

	def reservation_params
		raise Exceptions::Booking::NoReservationDataFound if params[:reservation].nil?
		params.require(:reservation).permit(:start_date, :end_date, :arrival_time, :special_details)
	end

	def reservation_user
		return current_user if not current_user.nil?
		return User.find_or_create_by_email(params[:user][:email]) if params[:user] and params[:user][:email]
		raise Exceptions::Booking::NoUserDataFound
	end

	def filter parameters
		parameters.select { |p| p.is_a? ActionController::Parameters } if parameters
	end
end
