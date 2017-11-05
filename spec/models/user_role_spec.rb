require 'rails_helper'

RSpec.describe UserRole, type: :model do

	let(:subject) { build :user_role }

	it { should belong_to :user }
	it { should belong_to :role }
	it { should validate_uniqueness_of(:role).scoped_to(:user_id) }
end
