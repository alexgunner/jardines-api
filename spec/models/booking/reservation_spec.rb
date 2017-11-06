require 'rails_helper'

RSpec.describe Booking::Reservation, type: :model do

	let(:subject) { create :reservation }
	
	it { should have_one :invoice }
	it { should have_many :guests }
	it { should have_many :room_reservations }
	it { should have_many :rooms }
	it { should belong_to :user }
	it { should validate_presence_of :start_date }
	it { should validate_presence_of :end_date }
	it { should validate_presence_of :arrival_time }
	# These tests are disable due to consistency checks made before
	# validation
	#it { should validate_presence_of :status }
	#it { should validate_presence_of :pin }
	it { should validate_numericality_of(:arrival_time).is_greater_than_or_equal_to(0) }
	it { should validate_numericality_of(:arrival_time).is_less_than(2400) }

	describe "validates date consitency" do
		let(:now) { Date.today }
		let(:yesterday) { now - 1.day }
		let(:tomorrow) { now + 1.day }

		context "when end date is after start date" do
			before do
				subject.start_date = now
				subject.end_date = tomorrow
			end

			it { should be_valid }
		end

		context "when end date is earlier or equal to start date" do
			context "when are equal" do
				before do
					subject.start_date = now
					subject.end_date = now
				end
				it { should_not be_valid }
			end

			context "when are different" do
				before do
					subject.start_date = now
					subject.end_date = yesterday
				end

				it { should_not be_valid }
			end
		end
	end


	describe "#cancelled?" do
		
		context "when reservation status is already cancelled" do
			let(:subject) { create :reservation, status: Booking::Reservation::CANCELLED }
			
			it "should return true" do
				expect(subject.cancelled?).to be true
			end
		end
		
		context "when reservations status is different from cancelled" do
			let(:subject) { create :reservation, status: Booking::Reservation::PENDING }
			it "should return false" do
				expect(subject.cancelled?).to be false
			end
		end
		
	end
	
	describe "#cancel" do
		let(:subject) { create :reservation, status: Booking::Reservation::PENDING }
		
		it "should create a change status record with the right old status, new status and reference to the reservation" do
			subject.cancel "I don't want this reservation anymore"
			status_change = Booking::StatusChange.find_by(object: subject)
			expect(subject).to eq(status_change.object)
			expect(status_change.old_status).to eq(Booking::Reservation::PENDING)
			expect(status_change.new_status).to eq(subject.status)
		end
		
		it "should create a change status message" do
			subject.cancel "I don't want this reservation anymore"
			status_change = Booking::StatusChange.find_by(object: subject)
			status_change_message = Booking::StatusChangeMessage.find_by(status_change: status_change)
			expect(status_change).to eq(status_change_message.status_change)
			expect(status_change_message.body).to eq("I don't want this reservation anymore")
		end
	end

	describe "#overlap" do
		let(:subject) { create :reservation, start_date: Date.today, end_date: 3.days.from_now }
		
		context "when attempt after reservation's end" do
			it "should be false" do
				expect(subject.overlaps 3.days.from_now, 5.days.from_now).to be false
			end
		end
		context "when attempt before reservation's end" do
			it "should be false" do
				expect(subject.overlaps 3.days.ago, Date.today).to be false
			end
		end
	end

	describe "#add_room" do

		describe "validates non overlapping dates" do
			let(:room) { create :room_with_price }
			let!(:room_reservation) { create :room_reservation, price: room.prices.current, reservation: reservation, room: room }

			context "when dates do not overlap" do
				context "when start just at the end of a reservation" do
					let(:reservation) { create :reservation, start_date: 1.day.from_now, end_date: 3.days.from_now }
					let(:subject) { create :reservation, start_date: 3.days.from_now, end_date: 5.days.from_now }

					it "should succeed" do
						expect(subject.add_room room).to be_truthy
					end
				end

				context "when ends just at the start of a reservation" do
					let(:reservation) { create :reservation, start_date: 3.day.from_now, end_date: 5.days.from_now }
					let(:subject) { create :reservation, start_date: 1.days.from_now, end_date: 3.days.from_now }

					it "should succeed" do
						expect(subject.add_room room).to be_truthy
					end
					it "should include the new room" do
						expect{ subject.add_room room }.to change{ subject.rooms.count }.by(1)
					end
				end
			end

			context "when dates overlap" do
				let(:reservation) { create :reservation, start_date: 1.day.from_now, end_date: 3.days.from_now }
				let(:subject) { create :reservation, start_date: 2.days.from_now, end_date: 4.days.from_now }
				
				it "should not succeed" do
					expect(subject.add_room room).to be_falsey
				end
				it "should not include the new room" do 
					expect{ subject.add_room room }.not_to change{ subject.rooms.count }
				end
			end
		end
	end

	describe "#add_room!" do
		context "when add_room fails" do
			before { allow(subject).to receive(:add_room).and_return(nil) }

			it "should raise RoomReservationOverlaps error" do
				expect{ subject.add_room! (create :room) }.to raise_error Exceptions::Booking::RoomReservationOverlaps
			end
		end

		context "when add_room does not fail" do

			before { allow(subject).to receive(:add_room).and_return(true) }

			it "should not raise error" do
				expect{ subject.add_room! nil }.not_to raise_error
			end
		end
	end

	describe "#add_guest_with_data" do
		let(:room) { create  :room_with_price }
		let(:room_id) { room.id }
		before { subject.add_room room }

		let(:guest_data) { attributes_for :guest, reservation: nil }
		let(:invalid_guest_data) { guest_data.except(:name) }

		context "when guest data is valid" do
			it "should return truthy value" do
				expect(subject.add_guest_with_data guest_data, to: room).to be_truthy
			end
		end

		context "when guest data is invalid (lacks minumum data)" do
			it "should return falsey value" do
				expect(subject.add_guest_with_data invalid_guest_data, to: room).to be_falsey
			end
		end

		context "when no room is specified" do
			it "should return falsey value" do
				expect(subject.add_guest_with_data guest_data).to be_falsey
			end
		end
	end

	describe "#add_guest" do
		let(:room) { create  :room_with_price }
		let(:room_id) { room.id }
		before { subject.add_room room }

		context "when adding more guests than room's capacity" do
			before do
				room.capacity.times do
					subject.add_guest build(:guest, room_reservation: nil), to: room_id
				end
			end
			let(:guest) { build :guest, room_reservation: nil }

			it "should fail" do
				expect(subject.add_guest guest, to: room_id).to be_falsey
			end
		end

		context "when guest is new" do
			let(:guest) { build :guest, room_reservation: nil }
			it "should succeed" do
				expect(subject.add_guest guest, to: room_id ).to be_truthy
			end
			it "should add it to guest list" do
				expect{ subject.add_guest guest, to: room_id }.to change{ subject.guests.count }.by 1
			end
		end

		context "when guest already has a reservation" do
			
			context "when is new" do
				let(:guest) { build :guest }

				it "should fail" do
					expect(subject.add_guest guest, to: room_id).to be_falsey
				end
			end

			context "when is persisted" do
				let(:guest) { create :guest }

				it "should fail" do
					expect(subject.add_guest guest, to: room_id).to be_falsey
				end 
			end
		end

		context "when no room is specified" do
			let(:guest) { build :guest, room_reservation: nil }
			it "should return a falsey value" do
				expect(subject.add_guest guest).to be_falsey
			end
		end
	end

	describe "add_guest_with_data!" do
		context "when add_guest_with_data succeeds" do
			before { allow(subject).to receive(:add_guest_with_data).and_return(true) }
			it "should not raise error" do
				expect{ subject.add_guest_with_data! nil }.not_to raise_error
			end
		end

		context "when add_guest_with_data fails" do
			before { allow(subject).to receive(:add_guest_with_data).and_return(false) }
			it "should raise InvalidGuestInformation error" do
				expect{ subject.add_guest_with_data! nil }.to raise_error Exceptions::Booking::InvalidGuestInformation
			end
		end
	end

	describe "add_guest!" do
		context "when add_guest succeeds" do
			before { allow(subject).to receive(:add_guest).and_return(true) }
			it "should not raise error" do
				expect{ subject.add_guest! nil }.not_to raise_error
			end
		end

		context "when add_guest fails" do
			before { allow(subject).to receive(:add_guest).and_return(false) }
			it "should raise InvalidGuestInformation error" do
				expect{ subject.add_guest! nil }.to raise_error Exceptions::Booking::InvalidGuest
			end
		end
	end
	
	describe "#check_out" do
		context "when it is not checked out yet" do 
			let(:subject) { create :reservation, start_date: Date.today, end_date: 10.days.from_now }
			let(:prices) { create_list :price, 3, status: Booking::Price::CURRENT, one_guest: 10, two_guests: 10 }
			let(:rooms) { prices.map { |p| p.room } }

			it "should return an invoice" do
				expect(subject.check_out).to be_an_instance_of Booking::Invoice
			end 

			it "should create the invoice" do
				expect{ subject.check_out }.to change{ Booking::Invoice.count }.by 1
			end

			it "should calculate the correct price" do
				rooms.map { |r| subject.add_room! r }
				rooms.each do |room|
					guest = build :guest, room_reservation: nil
					subject.add_guest guest, to: room
				end
				expect(subject.check_out.total).to eq 300
			end
		end

		context "when it is already checked_out" do

			before { subject.check_out }

			it "should return the invoice" do
				expect(subject.check_out).to be_an_instance_of Booking::Invoice
			end

			it "should not create any additional Invoice" do
				expect{ subject.check_out }.not_to change{ Booking::Invoice.count }
			end
		end
	end

	describe "invoice validation" do
		context "when is checked_out" do
			before{	allow(subject).to receive(:checked_out?).and_return(true) }
			it { should validate_presence_of :invoice }
		end

		context "when is not checked_out" do
			before{ allow(subject).to receive(:checked_out?).and_return(false) }
			it { should_not validate_presence_of :invoice }
		end
	end
end
