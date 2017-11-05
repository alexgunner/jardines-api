class User < ApplicationRecord
	has_many :user_roles
	has_many :roles, through: :user_roles
	has_many :reservations
	has_one :aggregated_user_datum
	has_many :reservations, class_name: "Booking::Reservation"

	validates_presence_of :aggregated_user_datum, if: :not_has_expanse_id?
	validates_uniqueness_of :expanse_id, if: :has_expanse_id?

	def self.find_or_create_by_email email
		aggregated_user_datum = AggregatedUserDatum.find_by(email: email)
		return aggregated_user_datum.user if not aggregated_user_datum.nil?
		AggregatedUserDatum.create(email: email, user: User.new).user
	end

	def find_reservation_by_pin pin
		reservations.find_by(pin: pin)
	end

	def user_role role_uid
		role = Role.find_by(uid: role_uid)
		self.user_roles.find_by(role_id: role.id) if role
	end

	private 

	def not_has_expanse_id?
		not has_expanse_id?
	end

	def has_expanse_id?
		has expanse_id
	end


# Why this?
=begin
	def find_reservation_by_pin(pin)
		reservation = self.reservations.find_by(pin: pin)
		return if !reservation.nil?
	end
=end
	
end
