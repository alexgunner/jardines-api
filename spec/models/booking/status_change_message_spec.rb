require 'rails_helper'

RSpec.describe Booking::StatusChangeMessage, type: :model do
  it { should belong_to :status_change }
  it { should validate_presence_of :body }
end
