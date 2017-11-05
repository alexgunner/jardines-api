class Exceptions::Booking::InvalidGuest < Exceptions::Booking::Exception
	def initialize
		super "Invalid Guest. Guest might have a current reservation."
	end
end