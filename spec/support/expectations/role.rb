RSpec::Matchers.define :contain_permission do |p_uid|
	match do |actual_role|
		not actual_role.permissions.find_by(uid: p_uid).nil?
	end
end
