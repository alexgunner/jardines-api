class Booking::Guest < ApplicationRecord
  belongs_to :room_reservation
  validates_presence_of :name

  def self.build data
	  return self.build_with data if data.has_key? :name
  end

  def self.build! data
  	raise Exceptions::Booking::InvalidGuestInformation if not self.build data	
  end

  private

  def self.build_with data
  	Booking::Guest.new(name: data[:name], id_number: data[:id_number], email: data[:email], nationality: data[:nationality])
  end
end