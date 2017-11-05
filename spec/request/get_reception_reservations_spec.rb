require "rails_helper"

RSpec.describe "GET /reception/reservations", type: :request do

	let!(:room_reservations) { create_list :room_reservation, 3 }
	
	before do
		room_reservations.each do |rr|
			create_list :guest, 3, room_reservation: rr
		end
		set_current_user receptionist_user
		get "/reception/reservations"
	end

	it "should return all reservations registered" do
		expect(json.size).to eq 3
	end

	it "should not return a pin within the reservations" do
		expect(json.sample[:pin]).to be nil
	end

	it "should have status 200" do
		expect(response).to have_http_status 200
	end

end
