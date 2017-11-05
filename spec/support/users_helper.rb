module UsersHelper

	def client_user 
		user_with_role Security::Roles::Client.create
	end

	def receptionist_user
		user_with_role Security::Roles::Receptionist.create
	end

	def user_with_role role
		user = create :user
		user.roles << role
		return user if user.save
	end
end