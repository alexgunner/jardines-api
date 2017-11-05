require 'rails_helper'

RSpec.describe Booking::Price, type: :model do
	it { should belong_to :room }
	it { should have_many :room_reservations }
	it { should have_many :reservations }
	it { should validate_presence_of :status }
	it { should validate_presence_of :one_guest }
	it { should validate_presence_of :two_guests }
	it { should validate_numericality_of(:one_guest).is_greater_than(0) }
	it { should validate_numericality_of(:two_guests).is_greater_than(0) }

	describe "uniquess of status CURRENT" do
		let(:room) { create :room }
		let(:subject) { build :price, room: room, status: Booking::Price::CURRENT }

		context "when is the only current price" do
			let!(:room_prices) { create_list :price, 5, room: room }
			it { should be_valid }
		end

		context "when room has already a current price" do
			let!(:room_prices) { create_list :price, 1, room: room, status: Booking::Price::CURRENT }
			it { should_not be_valid }
		end
	end
end
