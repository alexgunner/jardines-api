class Booking::Price < ApplicationRecord

  include Constants::Booking::Price

  belongs_to :room
  has_many :room_reservations
  has_many :reservations, through: :room_reservations
  validates_presence_of :one_guest
  validates_presence_of :two_guests
  validates_numericality_of :one_guest, greater_than: 0
  validates_numericality_of :two_guests, greater_than: 0
  validates_presence_of :status
  validates_uniqueness_of :status, scope: :room_id, if: :current?

  def current?
  	status == CURRENT
  end

end
