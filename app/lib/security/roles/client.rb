class Security::Roles::Client < Builders::RoleBuilder

	def self.uid
		1600000
	end

	def self.name
		"Client"
	end

	def self.permissions_list
		[]
	end
end