class Reception::ReservationsController < ApplicationController

	#check_role Security::Roles::Receptionist.uid, on: [:index, :cancel]

	def index
		render json: Booking::Reservation.all, status: :ok
	end

	def cancel
		
	end

end
