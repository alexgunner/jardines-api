class Booking::StatusChangeMessage < ApplicationRecord
  belongs_to :status_change
  validates_presence_of :body
end
