class Role < ApplicationRecord

	has_many :user_roles
	has_many :users, through: :user_roles
	validates_presence_of :uid
	validates_presence_of :name
	validates_uniqueness_of :uid
	validates_uniqueness_of :name

end
