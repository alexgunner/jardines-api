require 'rails_helper'

RSpec.describe Booking::StatusChange, type: :model do
	it { should belong_to :object }
	it { should validate_presence_of :old_status }
	it { should validate_presence_of :new_status }
end
