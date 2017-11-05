require 'rails_helper'

RSpec.describe Booking::RoomReservation, type: :model do

	it { should belong_to :room }
	it { should belong_to :reservation }
	it { should belong_to :price }
	it { should have_many :guests }

	describe "consistency validation" do
		let(:subject) { create :room_reservation }
		let(:room) { create :room }

		context 'when created' do
			it { should be_valid }
		end

		context 'when another room is not price\'s room' do	
			before { subject.room = room }
			it { should_not be_valid }
		end
	end

	describe "add_guest" do
		let(:subject) { create :room_reservation }
		context "when guest does not have reservation" do
			let(:guest) { build :guest, room_reservation: nil }
			it "should succeed" do
				expect(subject.add_guest guest).to be_truthy
			end
			it "should increase guest count" do
				expect{ subject.add_guest guest }.to change{ subject.guests.count }.by 1
			end
		end

		context "when guest does have a reservation" do
			let(:guest) { create :guest }
			it "should fail" do
				expect(subject.add_guest guest).to be_falsey
			end

			it "should not change guest count" do
				expect{ subject.add_guest guest }.not_to change{ subject.guests.count }
			end
		end

		context "when guest does not exist" do
			let(:guest) { nil }

			it "should fail" do
				expect(subject.add_guest guest).to be_falsey
			end

			it "should not change guest count" do
				expect{ subject.add_guest guest }.not_to change{ subject.guests.count }
			end
		end

		context "when room is fully booked" do
			let(:guest) { build :guest, room_reservation: nil }
			before { allow(subject).to receive(:fully_booked?).and_return(true) }

			it "should fail" do
				expect(subject.add_guest guest).to be_falsey
			end

			it "should not change guest count" do
				expect{ subject.add_guest guest }.not_to change{ subject.guests.count }
			end
		end
	end

	describe "fully_booked?" do
		let(:subject) { create :room_reservation }
		context "when no guest is stated" do
			it "should be false" do
				expect(subject.fully_booked?).to be false
			end
		end
		context "when guests count is lower then the rooms capacity" do
			before { allow(subject.guests).to receive(:count).and_return(subject.room.capacity-1) }
			it "should be false" do
				expect(subject.fully_booked?).to be false
			end
		end
		context "when guests count is the room capacity" do
			before { allow(subject.guests).to receive(:count).and_return(subject.room.capacity) }
			it "should be true" do
				expect(subject.fully_booked?).to be true
			end
		end
	end
end
