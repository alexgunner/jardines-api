module ExceptionHandler
	extend ActiveSupport::Concern

	included do
		rescue_from Exceptions::Booking::Exception, with: :four_hundred
		rescue_from ActiveRecord::RecordInvalid, with: :four_hundred
		rescue_from Security::Exceptions::UserNotLoggedIn, with: :unauthorized_request
	end

	private

	def four_hundred e
		respond_with e, :bad_request
	end

	def unauthorized_request e
		respond_with e, :unauthorized
	end

	def respond_with e, status
		render json: { message: e.message }, status: status
	end

end