class Reception::ReservationsController < ApplicationController

	#check_role Security::Roles::Receptionist.uid, on: [:index, :cancel]

	def index
		render json: Booking::Reservation.all, status: :ok
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

end
