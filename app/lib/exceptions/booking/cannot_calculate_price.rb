class Exceptions::Booking::CannotCalculatePrice < Exceptions::Booking::Exception
	def initialize pax
		super "Cannot calculate price. Can't calculate price for room with #{pax} guest(s)."
	end
end