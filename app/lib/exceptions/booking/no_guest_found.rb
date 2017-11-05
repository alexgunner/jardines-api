class Exceptions::Booking::NoGuestFound < Exceptions::Booking::Exception
	def initialize
		super "No guest data found. Can't create a reservation with no guests."
	end
end