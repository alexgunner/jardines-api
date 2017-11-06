class Booking::Reservation < ApplicationRecord

  PENDING = 1000002
  CANCELLED = 1000004

  include Constants::Booking::Reservation

  belongs_to :user
  has_one :invoice
  has_many :room_reservations
  has_many :guests, through: :room_reservations
  has_many :rooms, through: :room_reservations
  validates_presence_of :start_date
  validates_presence_of :end_date
  validates_presence_of :arrival_time
  validates_presence_of :status
  validates_presence_of :pin
  validates_numericality_of :arrival_time, greater_than_or_equal_to: 0, less_than: 2400
  validates_presence_of :invoice, if: :checked_out?
  validate :data_consistency

  before_validation :check_status
  before_validation :check_pin

  def cancelled?
    self.status == Booking::Reservation::CANCELLED
  end
  
  def cancel message
    status_change = Booking::StatusChange.create!(old_status: self.status, new_status: Booking::Reservation::CANCELLED, object: self)
    status_change_message = Booking::StatusChangeMessage.create!(status_change: status_change, body: message)
    self.status = Booking::Reservation::CANCELLED
    Booking::Invoice.make_cancellation_invoice_for self
    self.save
  end

  def check_out
    return invoice if invoice
    Booking::Invoice.make_invoice_for self
  end

  def checked_out?
    self.status == Booking::Reservation::CHECKED_OUT
  end

  def add_room room
    if room.available from: start_date, until: end_date
      return Booking::RoomReservation.create!(room: room, price: room.prices.current, reservation: self)
    end
  end

  def add_room! room
    raise Exceptions::Booking::RoomReservationOverlaps, room if not add_room room
  end

  def add_guest guest, vars = {}
    room_id = vars[:to].instance_of?(Booking::Room) ? vars[:to].id : vars[:to]
    room_reservation = self.room_reservations.find_by(room_id: room_id)
    return room_reservation.add_guest guest if room_reservation
  end

  def add_guest! guest, vars = {}
    raise Exceptions::Booking::InvalidGuest if not add_guest guest, vars
  end

  def add_guest_with_data data, vars = {}
    add_guest Booking::Guest.build(data), vars
  end

  def add_guest_with_data! data, vars = {}
    raise Exceptions::Booking::InvalidGuestInformation if not add_guest_with_data data, vars
  end

  def overlaps start_date, end_date
    not (start_date >= self.end_date || end_date <= self.start_date)
  end

  def total
    room_reservations.inject(0){ |sum, r| sum + r.amount } * stay_length
  end

  def stay_length
    (end_date - start_date).to_i
  end


  private

  def data_consistency
  	errors.add(:end_date, "must be after start_date") if not dates_are_consistent?
  end

  def dates_are_consistent?
  	start_date and end_date and start_date < end_date
  end

  def change_reservation_status(status)
    self.status = status
    self.save
  end

  def set_cancellation_reason(reason)
    Booking::StatusChange.create!(old_status: PENDING, new_status: CANCELLED)
  end

  def check_status
    self.status ||= Booking::Reservation::PENDING
  end

  def check_pin
    if self.pin.nil?
      loop do
        self.pin = generate_pin
        break if user.find_reservation_by_pin(self.pin).nil?
      end
    end
  end

  def generate_pin
    6.times.map { [*'0'..'9', *'A'..'Z'].sample }.join
  end

end