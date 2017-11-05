require 'rails_helper'

RSpec.describe "GET /reservations/history", type: :request do

	context "when no user is logged in" do

		before { get "/reservations/history" }

		it "should have http status 401 unauthorized" do
			expect(response).to have_http_status 401
		end

		it "should have message: not logged in" do
			expect(json['message']).to match /not logged in/
		end
	end
	
	context "when user is logged in" do

		let(:user) { client_user }
		before { set_current_user user }

		it "should have http status 200" do
			get "/reservations/history"
			expect(response).to have_http_status 200
		end

		context "when user does not have reservations" do
			it "should not return reservations" do
				get "/reservations/history"
				expect(json.size).to eq 0
			end
		end

		context "when user does have 3 reservations" do
			let(:reservations) { create_list :reservation, 3, user: user }
			let(:detailess_reservation) { create :reservation, user: user, special_details: nil }
			before :each do
				reservations.each do |r|
					room = create(:room_with_price)
					r.add_room! room
					r.add_guest! build(:guest, room_reservation: nil), to: room
				end

				room = create(:room_with_price)
				
				detailess_reservation.add_room! room
				detailess_reservation.add_guest! build(:guest, room_reservation: nil), to: room

				reservations.sample.check_out

				get "/reservations/history"				
			end
			it "should return 4 reservations" do
				expect(json.size).to eq 4
			end

			it "should return reservation details" do

				json.each do |j|

					expect(j["rooms"]).not_to be_nil
					expect(j["guests"]).not_to be_nil
					expect(j["owner"]).not_to be_nil
					expect(j["arrival_time"]).not_to be_nil
					expect(j["start_date"]).not_to be_nil
					expect(j["special_details"]).not_to be_nil
					expect(j["status"]).not_to be_nil

					if (j["status"] == Booking::Reservation::CHECKED_OUT)
						expect(j["invoice"]).not_to be_nil
					end
				end
			end
		end
	end
end