class Exceptions::Booking::NoRoomDataFound < Exceptions::Booking::Exception
	def initialize
		super "No room data found. Add rooms to your reservation." 
	end
end