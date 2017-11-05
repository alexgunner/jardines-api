class Booking::Invoice < ApplicationRecord

  PENDING = 1

  belongs_to :reservation

  validates_presence_of :total
  validates_presence_of :status
  validates_numericality_of :total, greater_than_or_equal_to: 0

  def self.make_invoice_for reservation

  	self.transaction do
  		reservation.invoice = Booking::Invoice.create!(total: reservation.total, status: Booking::Invoice::PENDING, reservation: reservation)
  		reservation.status = Booking::Reservation::CHECKED_OUT
  		reservation.save!
  	end

  	return reservation.invoice
  end

end
