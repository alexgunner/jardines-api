class Booking::Invoice < ApplicationRecord

  PENDING = 1
  CANCELLED = 2

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
  
  def self.make_cancellation_invoice_for reservation
    cost_of_cancellation = 0
    cancellation_date = Date.today
    free_cancellation_top_date = cancellation_date + Booking::Reservation::CANCELLATION_DAYS.days
    if free_cancellation_top_date > reservation.start_date
      cost_of_cancellation = reservation.total
    end
    reservation.invoice = Booking::Invoice.create!(total: cost_of_cancellation, status: Booking::Invoice::CANCELLED, reservation: reservation)
    reservation.save!
  end

end
