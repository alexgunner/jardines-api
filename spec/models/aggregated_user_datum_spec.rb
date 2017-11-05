require 'rails_helper'

RSpec.describe AggregatedUserDatum, type: :model do
	
	let(:subject) { create :aggregated_user_datum }

	it { should belong_to :user }
	it { should validate_presence_of :email }
	it { should allow_value("foo@bar.biz").for(:email) }
	it { should allow_value("f.s@b.b").for(:email) }
	it { should_not allow_value("lala").for(:email) }

	it { should validate_uniqueness_of :user }
	it { should validate_uniqueness_of(:email).case_insensitive }
end
