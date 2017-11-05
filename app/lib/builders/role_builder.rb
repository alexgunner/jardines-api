class Builders::RoleBuilder
	def self.build
		role = Role.find_by(uid: uid)

		if role.nil?
			role = Role.new(name: name, uid: uid) 

			permissions.each do |p|
				role.permissions << p
			end
		end

		return role
	end

	def self.create
		role = build
		return role if role.save
	end

	def self.create!
		role = build
		return role if role.save!
	end

	def self.permissions
		permissions_list.map{ |p| Builders::PermissionBuilder.build p }
	end
end