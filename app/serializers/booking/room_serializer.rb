class Booking::RoomSerializer < ActiveModel::Serializer
  attributes :id, :current_price, :name, :description, :capacity, :type
  has_many :upcoming_reservations do
  	object.reservations.upcoming
  end

  def current_price
  	if object.apartment?
  		return object.prices.current.one_guest
  	else 
  		return {
  			one_guest: object.prices.current.one_guest,
  			two_guests: object.prices.current.two_guests
  		}
  	end
  end

  def type
  	return "room" if object.room?
  	return "apartment" if object.apartment?
  end

  class Booking::ReservationSerializer < ActiveModel::Serializer
  	attributes :start_date, :end_date
  end

end
