Rails.application.routes.draw do
	get "rooms", to: "rooms#index"
	resources :reservations, only: [:create, :show, :update] do
		collection do
			put "/cancel", action: :cancel
			get "history"
		end
	end

	namespace :reception do
		resources :reservations, only: :index do
			put "cancel"
		end
	end
end

