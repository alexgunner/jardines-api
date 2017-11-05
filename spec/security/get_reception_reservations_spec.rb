require 'rails_helper'

RSpec.describe "GET /reception/reservations", type: :request do
	expect_endpoint '/reception/reservations', to: :allow, user: :receptionist_user
	expect_endpoint '/reception/reservations', to: :deny, user: :client_user
end