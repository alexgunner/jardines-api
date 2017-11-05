class ApplicationController < ActionController::API


	include ExceptionHandler
	include Security::Checkings

	def current_user
		nil
	end
end
