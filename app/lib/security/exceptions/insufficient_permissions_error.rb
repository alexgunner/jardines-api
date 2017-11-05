class Security::Exceptions::InsufficientPermissionsError < StandardError
	def initialize
		super "Operation denied. Insufficient permissions."
	end
end