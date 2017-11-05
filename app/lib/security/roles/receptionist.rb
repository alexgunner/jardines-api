class Security::Roles::Receptionist < Builders::RoleBuilder

	def self.uid
		1600001
	end

	def self.name
		"Receptionist"
	end

	def self.permissions_list
		[]
	end
end