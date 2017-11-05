class RoomsController < ApplicationController
	
	def index
		render json: Booking::Room.all, status: :ok
	end	
end
