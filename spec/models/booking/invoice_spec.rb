require 'rails_helper'

RSpec.describe Booking::Invoice, type: :model do
	it { should belong_to :reservation }
	it { should validate_presence_of :total }
	it { should validate_presence_of :status }
	it { should validate_numericality_of(:total).is_greater_than_or_equal_to(0) }
end
