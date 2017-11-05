require 'rails_helper'

RSpec.describe Booking::Guest, type: :model do
	it { should belong_to :room_reservation }
	it { should validate_presence_of :name }

	describe "self.build" do
		let(:guest_data) { attributes_for :guest, reservation: nil }
		let(:invalid_guest_data) { guest_data.except(:name) }
		context "when data is valid" do

			let(:guest) { Booking::Guest.build guest_data }

			it "should return a guest instance" do
				expect(guest).to be_an_instance_of Booking::Guest
			end
			it "should not be persisted" do
				expect(guest).to be_a_new Booking::Guest
			end
		end

		context "when data is invalid" do
			let(:guest) { Booking::Guest.build invalid_guest_data }
			it "should return falsey value" do
				expect(guest).to be_falsey
			end

			it "should not create any more guests" do
				expect{ guest }.not_to change{ Booking::Guest.count }
			end
		end
	end

	describe "self.build!" do
		context "when build is successful" do
			before { allow(Booking::Guest).to receive(:build).and_return(true) }
			it "should not raise error" do
				expect{ Booking::Guest.build! nil }.not_to raise_error
			end
		end
		context "when build fails" do
			before { allow(Booking::Guest).to receive(:build).and_return(false) }
			it "should raise InvalidGuestInformation error" do
				expect{ Booking::Guest.build! nil }.to raise_error Exceptions::Booking::InvalidGuestInformation
			end
		end
	end
end
