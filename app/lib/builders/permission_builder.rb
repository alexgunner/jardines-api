class Builders::PermissionBuilder
	def self.build p_uid
		permission = Permission.find_by(uid: p_uid)
		return permission if not permission.nil?
		return Permission.new(uid: p_uid, name: "Unknown permission")
	end
end