class Booking::ReservationSerializer < ActiveModel::Serializer
  attributes :id, :owner, :arrival_time, :start_date, :end_date, :special_details, :status
  has_many :rooms
  has_many :guests
  has_one :invoice, if: 'object.checked_out?'

  def owner
  	object.user
  end

  def special_details
  	return object.special_details if object.special_details
  	""
  end

end
