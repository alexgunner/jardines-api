class Booking::StatusChange < ApplicationRecord
  belongs_to :object, polymorphic: true
  validates_presence_of :old_status
  validates_presence_of :new_status
end
