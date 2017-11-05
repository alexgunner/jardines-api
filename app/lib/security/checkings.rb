module Security::Checkings

	def current_user_permissions
		current_user.permissions.map { |p| p.uid }
	end

	def current_user_roles
		current_user.roles.map { |r| r.uid }
	end

	def forbid_access
		raise Security::Exceptions::InsufficientPermissionsError
	end

	def ask_login
		raise Security::Exceptions::UserNotLoggedIn
	end

	def user_has_role vars
		user_role = current_user.user_role(vars[:role])
		
		if vars.has_key? :over
			obj = vars[:over]

			user_role and user_role.over self.send(obj)
		else
			user_role
		end
	end

	def self.included(base)
		base.extend ClassMethods
	end

	module ClassMethods

		def check_permission p_uid, vars
			raise Security::Exceptions::Checkings::TargetMethodNotDefined if not vars.has_key? :on
				
			before_action only: vars[:on] do
				ask_login if current_user.nil?
				forbid_access if not current_user_permissions.include? p_uid
			end
		end

		def check_role r_uid, vars
			raise Security::Exceptions::Checkings::TargetMethodNotDefined if not vars.has_key? :on

			before_action only: vars[:on] do
				ask_login if current_user.nil?
				vars[:role] = r_uid
				forbid_access if not user_has_role vars
			end
		end

		def check_any_role role_dscr, vars
			raise Security::Exceptions::Checkings::TargetMethodNotDefined if not vars.has_key? :on
			
			before_action only: vars[:on] do
				ask_login if current_user.nil?
				valid_roles_count = 0
				role_dscr.each do |rd| 
					if not rd.is_a? Hash
						rd = { role: rd }
					end
					valid_roles_count += 1 if user_has_role rd 
				end

				forbid_access if valid_roles_count == 0
			end
		end
	end
end