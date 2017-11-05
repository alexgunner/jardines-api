class Exceptions::Booking::NoUserDataFound < Exceptions::Booking::Exception
	def initialize
		super "No user data found. Please log in or specify an email." 
	end
end