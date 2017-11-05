class Exceptions::Booking::RoomReservationOverlaps < Exceptions::Booking::Exception
	def initialize room
		super "Can't reserve room #{room.name}. This reservation overlaps with one of the room's current reservations."
	end
end