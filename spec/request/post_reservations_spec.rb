require "rails_helper"

RSpec.describe "POST /reservations", type: :request do

	context "when no user is signed in" do

		let(:reservation_params) { non_user_reservation_params }

		context "when request is valid" do
			it "should return status code 201" do
				post "/reservations", params: reservation_params
				expect(response).to have_http_status 201
			end

			it "should create Reservation" do
				expect { post "/reservations", params: reservation_params }.to change{ Booking::Reservation.count }.by 1
			end

			it "should create Guests" do
				total_guests  = 0
				reservation_params[:rooms].each do |r|
					total_guests += r[:guests].size
				end

				expect { post "/reservations", params: reservation_params }.to change{ Booking::Guest.count }.by total_guests
			end
		end
	end

	context "when user is signed in" do
		let(:reservation_params) { logged_user_reservation_params }
		before { set_current_user create(:user) }

		context "when request is valid" do
			it "should return status code 201" do
				post "/reservations", params: reservation_params
				expect(response).to have_http_status 201
			end

			it "should create Reservation" do
				expect { post "/reservations", params: reservation_params }.to change{ Booking::Reservation.count }.by 1
			end

			it "should create Guests" do
				total_guests  = 0
				reservation_params[:rooms].each do |r|
					total_guests += r[:guests].size
				end
				expect { post "/reservations", params: reservation_params }.to change{ Booking::Guest.count }.by total_guests
			end
		end
	end

	context "when request is invalid" do
		let(:reservation_params) { non_user_reservation_params }
		let!(:rooms) { create_list :room_with_price , 2}
		before { post "/reservations", params: invalid_params }
		
		context "when no guest is mentioned" do
			let(:invalid_params) { non_user_reservation_params rooms: [{ id: rooms[0].id, guests: [] }, { id: rooms[1].id, guests: [] }]  }

			it "should have http status 400" do
				expect(response).to have_http_status 400
			end

			it "should have message matching no guest data found" do
				expect(json["message"]).to match /No guest data found/
			end
		end

		context "when guest list is nil" do
			let(:invalid_params) { non_user_reservation_params rooms: [{ id: rooms[0].id, guests: [] }, { id: rooms[1].id, guests: [] }]  }
			it "should have http status 400" do
				expect(response).to have_http_status 400
			end

			it "should have message matching no guest data found" do
				expect(json["message"]).to match /No guest data found/
			end
		end

		context "when no user is listed" do
			context "when user is empty" do
				let(:invalid_params) { non_user_reservation_params user: {} }
				it "should have http status 400" do
					expect(response).to have_http_status 400
				end

				it "should have message matching no user data found" do
					expect(json["message"]).to match /No user data found/
				end
			end

			context "when user is nil" do
				let(:invalid_params) { reservation_params.except(:user) }
				it "should have http status 400" do
					expect(response).to have_http_status 400
				end

				it "should have message matching no user data found" do
					expect(json["message"]).to match /No user data found/
				end
			end
		end

		context "when rooms are invalid" do
			context "when no room is listed" do
				let(:invalid_params) { non_user_reservation_params rooms: {} }

				it "should have http status 400" do
					expect(response).to have_http_status 400
				end

				it "should have message matching no room data found" do
					expect(json["message"]).to match /No room data found/
				end
			end

			context "when rooms is nil" do
				let(:invalid_params) { reservation_params.except(:rooms) }

				it "should have http status 400" do
					expect(response).to have_http_status 400
				end

				it "should have message matching no room data found" do
					expect(json["message"]).to match /No room data found/
				end
			end

			context "when a room is not available" do
				let(:room_reservation) { create :room_reservation, reservation: create(:reservation, start_date: 1.day.from_now, end_date: 100.days.from_now) }
				let(:invalid_params) { non_user_reservation_params rooms: [ { id: room_reservation.room_id, guests: [ attributes_for(:guest, room_reservation: nil)] } ] }

				it "should have http status 400" do
					expect(response).to have_http_status 400
				end

				it "should have message matching can't reserve room" do
					expect(json["message"]).to match /Can't reserve room/
				end
			end
		end

		context "when reservation data is invalid" do
			context "when reservation fails validation" do

				let(:invalid_params) { non_user_reservation_params reservation: { arrival_time: -1229 } }

				it "should have http status 400" do
					expect(response).to have_http_status 400
				end 		

				it "should have error message matching invalid" do
					expect(json["message"]).to match /Validation failed/
				end
			end

			context "when reservation data is empty" do
				let(:invalid_params) { non_user_reservation_params reservation: {} }

				it "should have http status 400" do
					expect(response).to have_http_status 400
				end 		

				it "should have error message matching invalid" do
					expect(json["message"]).to match /No reservation data found/
				end
			end

			context "when resevation data is nil" do
				let(:invalid_params) { reservation_params.except(:reservation) }

				it "should have http status 400" do
					expect(response).to have_http_status 400
				end 		

				it "should have error message matching invalid" do
					expect(json["message"]).to match /No reservation data found/
				end
			end					
		end
	end
end