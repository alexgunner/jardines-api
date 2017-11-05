class Exceptions::Booking::InvalidGuestInformation < StandardError
	def initialize
		super "Invalid Guest Information. Some required attributes are missing"
	end
end