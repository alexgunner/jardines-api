class UserRole < ApplicationRecord
  belongs_to :user
  belongs_to :role

  validates_uniqueness_of :role, scope: :user_id
end
