Rails.application.routes.draw do
	get '/schedules/calendar', to: 'schedules#calendar', as:'schedules_calender'

	resources :rooms
	resources :areas
	resources :schedules
	resources :salons
	devise_for :users, controllers: {
		sessions: 'users/sessions',
		registrations: 'users/registrations'
	}
	root 'pages#index'
	get 'pages/index'
	get 'pages/show'

	get '/rooms/new/:area_id', to: 'rooms#new', as: 'new_room_from_area'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
