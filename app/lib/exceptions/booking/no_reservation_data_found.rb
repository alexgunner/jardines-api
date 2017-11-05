class Exceptions::Booking::NoReservationDataFound < Exceptions::Booking::Exception
	def initialize
		super "No reservation data found. Can't create an empty reservation."
	end
end