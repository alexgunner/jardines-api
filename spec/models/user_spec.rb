require 'rails_helper'

RSpec.describe User, type: :model do
	it { should have_many :roles }
	it { should have_many :user_roles }
	it { should have_one :aggregated_user_datum }
	it { should have_many :reservations }

	context "when does not have expanse id" do
		let(:subject) { build :user, expanse_id: nil }

		it { should validate_presence_of :aggregated_user_datum }
	end

	context "when has expanse id" do
		let(:subject) { build :user }
		it { should_not validate_presence_of :aggregated_user_datum }
		it { should validate_uniqueness_of :expanse_id }
	end
end
