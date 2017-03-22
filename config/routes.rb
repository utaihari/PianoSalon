Rails.application.routes.draw do

	get '/schedules/calendar/:room_id', to: 'schedules#calendar', as: 'calendar'
	get '/schedules/get_schedules/:room_id', to: 'schedules#get_schedules'
	get '/schedules/new/:room_id/:datetime', to: 'schedules#new'
	get '/schedules/check_overlap/:room_id/:start_time/:end_time', to: 'schedules#check_overlap'
	get '/reservations/create/:schedule_id', to: 'reservations#create', as: 'reservation_create'
	get '/reservations/approve/:id/:approve', to: 'reservations#approve', as: 'reservation_approve'


	get '/pages/notices', to: 'pages#notices', as:'notices'
	get '/pages/notice/:id', to: 'pages#notice_show', as:'notice'
	delete '/pages/notice/:id', to: 'pages#notice_destroy'

	get '/salons/manage/:id', to: 'salons#manage', as:'manage'
	post '/salons/manage_update', to: 'salons#manage_update', as:'manage_update'

	get '/reservations/new/:schedule_id', to: 'reservations#new'

	resources :reservations
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
