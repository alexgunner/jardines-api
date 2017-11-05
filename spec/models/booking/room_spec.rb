require 'rails_helper'

RSpec.describe Booking::Room, type: :model do
		
	let(:subject) { create :room }

	it { should have_many :room_reservations }
	it { should have_many :reservations }
	it { should have_many :prices }
	it { should validate_presence_of :description }
	it { should validate_presence_of :name }
	it { should validate_presence_of :capacity }
	it { should validate_numericality_of(:capacity).is_greater_than(0).is_less_than(20) }
	it { should validate_inclusion_of(:capacity).in_array([2, 4])}

	describe "current price" do
		context "when no current price is set" do
			it "should be nil" do
				expect(subject.prices.current).to be_nil
			end
		end

		context "when current price is set" do
			let!(:price) { create :price, room: subject, status: Booking::Price::CURRENT }
			it "should not be nil" do
				expect(subject.prices.current).not_to be_nil
			end
		end
	end

	describe "set current price" do

		let(:new_price) { build :price, room: nil, status: nil }

		context "when no current price is set" do
			it "should be nil" do
				subject.prices.current = new_price
				expect(subject.prices.current).to eq new_price
			end
		end

		context "when current price is set" do
			let!(:price) { create :price, room: subject, status: Booking::Price::CURRENT }
			it "should not be nil" do
				subject.prices.current = new_price
				price.reload
				expect(price.current?).to be false
			end
		end
	end

	describe "#type" do
		context "when has capacity 2"
			let(:subject) { create :room, capacity: 2 }
			it "should be of type room" do
				expect(subject.type).to eq Booking::Room::TYPE_ROOM
			end
		end

		context "when has capacity 4" do
		let(:subject) { create :room, capacity: 4 }
		it "should be of type apartment" do
			expect(subject.type).to eq Booking::Room::TYPE_APARTMENT
		end
	end

	describe "type validation" do
		context "when has capacity 2" do
			let(:subject) { build :room, capacity: 2 }
			it { should be_valid }
		end

		context "when has capacity 4" do
			let(:subject) { build :room, capacity: 4 }
			it { should be_valid }
		end

		context "when has capacity other than 2 or 4" do
			let(:subject) { build :room, capacity: 3 }
			it { should_not be_valid }
		end
	end

	describe "price_for" do
		context "when is a room" do
			let(:subject) { create :room_with_price, capacity: 2 }
			context "when number of guests given is ok" do
				it "should return different values" do
					expect(subject.price_for 1).to eq subject.prices.current.one_guest
					expect(subject.price_for 2).to eq subject.prices.current.two_guests
				end
			end
			context "when number of guests given is not ok" do
				it "should raise can't calculate price error" do
					expect{ subject.price_for 0 }.to raise_error Exceptions::Booking::CannotCalculatePrice
					expect{ subject.price_for 3 }.to raise_error Exceptions::Booking::CannotCalculatePrice
				end
			end
		end

		context "when is a department" do
			let(:subject) { create :room_with_price, capacity: 4 }
			context "when number of guest given is ok" do
				it "should return always the same value" do
					expect(subject.price_for 1).to eq subject.prices.current.one_guest
					expect(subject.price_for 2).to eq subject.prices.current.one_guest
					expect(subject.price_for 3).to eq subject.prices.current.one_guest
					expect(subject.price_for 4).to eq subject.prices.current.one_guest
				end
			end

			context "when number of guests given is not ok" do
				it "should raise can't calculate price error" do
					expect{ subject.price_for 0 }.to raise_error Exceptions::Booking::CannotCalculatePrice
					expect{ subject.price_for 5 }.to raise_error Exceptions::Booking::CannotCalculatePrice
				end
			end
		end
	end
end
