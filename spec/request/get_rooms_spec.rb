require 'rails_helper'

RSpec.describe "GET /rooms", type: :request do
	describe "return a list with rooms" do

		it "should have http status 200" do
			get "/rooms" 
			expect(response).to have_http_status 200
		end

		context "when rooms exist" do
			let!(:rooms) { create_list :room_with_price, 7 }

			it "should return 7 rooms" do
				get "/rooms" 
				expect(json.size).to eq 7
			end
		end

		context "when rooms have reservations" do
			let!(:room_reservation) { create :room_reservation }
			let(:reservation) { room_reservation.reservation }
			it 'should return reservation interval for room' do
				get "/rooms"
				expect(json[0]["upcoming_reservations"][0]).not_to be_nil
				expect(json[0]["upcoming_reservations"][0]["start_date"]).to eq reservation.start_date.to_s
				expect(json[0]["upcoming_reservations"][0]["end_date"]).to eq reservation.end_date.to_s
			end
		end

		context "when rooms have reservations before the actual date" do
			let(:reservation) { create :reservation, start_date: 3.days.ago, end_date: 2.days.ago }
			let!(:room_reservation) { create :room_reservation, reservation: reservation }

			it "should not have reservations" do
				get "/rooms"
				expect(json[0]["upcoming_reservations"].size).to eq 0
			end
		end

	end
end