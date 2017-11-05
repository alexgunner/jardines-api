class AggregatedUserDatum < ApplicationRecord
  belongs_to :user
  validates_presence_of :email
  validates :email, format: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  validates_uniqueness_of :user
  validates_uniqueness_of :email, case_sensitive: false
end
