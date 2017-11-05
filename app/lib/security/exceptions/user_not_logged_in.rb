class Security::Exceptions::UserNotLoggedIn < StandardError
	def initialize
		super "Operation denied. User not logged in."
	end
end