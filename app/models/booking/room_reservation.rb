class Booking::RoomReservation < ApplicationRecord
  belongs_to :room
  belongs_to :price
  belongs_to :reservation
  has_many :guests
  validate :data_consistency

  def add_guest guest
    return self.guests << guest if guest and guest.room_reservation.nil? and not fully_booked?
  end

  def fully_booked?
    room.capacity == guests.count    
  end

  def amount
    room.price_for guests.count
  end
  
  private

  def data_consistency
  	errors.add(:price, "should belong to room #{room_id}") if not price_is_consistent?
  end

  def price_is_consistent?
  	price.room_id == room_id
  end

end
