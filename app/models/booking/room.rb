class Booking::Room < ApplicationRecord

	include Constants::Booking::Room

	has_many :room_reservations
	has_many :reservations, through: :room_reservations do
		def upcoming
			where("end_date >= ?", Date.today)			
		end
	end

	has_many :prices do
		def current
			find_by(status: Booking::Price::CURRENT)
		end
		def current= price
			current.update(status: Booking::Price::OLD) if current
			price.status = Booking::Price::CURRENT
			self<<price
			price.save
		end
	end

	validates_presence_of :description
	validates_presence_of :name
	validates_presence_of :capacity
	validates_numericality_of :capacity, less_than: 20, greater_than: 0
	validates :capacity, inclusion: { in: [2, 4] }

	def available vars
		available = true
		reservations.upcoming.each do |r|
			available &&= not(r.overlaps vars[:from], vars[:until])
		end
		available
	end

	def apartment?
		self.capacity == 4
	end

	def room?
		self.capacity == 2
	end

	def type
		return TYPE_ROOM if room?
		return TYPE_APARTMENT if apartment?
	end

	def price_for pax
		raise Exceptions::Booking::CannotCalculatePrice, pax if pax == 0 or pax > capacity
		return prices.current.one_guest if apartment? or pax == 1
		return prices.current.two_guests if pax == 2
	end

end
