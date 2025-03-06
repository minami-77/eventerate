Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Fluff routes
  # Needs to be at the top or there'll be issues
  get "events/preview_event", to: "events#fake_preview", as: :preview_event
  get "events/regenerated_preview", to: "events#fake_regenerated_preview", as: :regenerated_preview

  # Defines the root path route ("/")
  # root "posts#index"
  post "events/:id/ai_tasks", to: "tasks#create_ai_task", as: :ai_task
  patch "tasks/:id", to: "tasks#update_from_modal", as: :update_task_from_modal

  resources :tasks, only: [:index]
  resources :events, only: [:create, :new, :show, :edit, :update] do
    resources :tasks, only: [:create, :update, :destroy]
      member do
        get 'preview_event_plan'
        get 'regenerated_activities'
        post 'save_event_plan'
        post 'save_fake_event_plan'
      end
  end

  get "/regenerate_activity", to: "events#regenerate_activity"
  patch "/update_tasks_users", to: "tasks_users#update_tasks_users"

  resources :tasks, only: [] do
    member do
      patch :complete
      patch :incomplete
    end
  end

  # # Routes for regenerating selected activities and saving the event
  # post 'events/:id/regenerate_selected_activities', to: 'events#regenerate_selected_activities', as: 'regenerate_selected_activities_event'
  # post 'events/:id/save_event_plan', to: 'events#save_event_plan', as: 'save_event_plan_event'

  get "/chats/get_last_message", to: "chats#get_last_message"
  resources :chats, only: [:index, :show]

  resources :messages, only: [:create]
  patch "user/change_profile_picture", to: "users#change_profile_picture", as: :change_profile_picture

  # reasources :events, only: [:create, :new]
  get "invite_link", to: "invites#invite_link"
  get "organizations/join", to: "invites#join"
  post "organizations/invite_result", to: "invites#invite_result"
  get "events/:event_id/activities/new", to: "activities_events#new", as: :new_activity
  post "events/:event_id/activities", to: "activities_events#create", as: :create_activity
  get "events/:event_id/activities/:id/edit", to: "activities_events#edit", as: :edit_activity
  patch "events/:event_id/activities/:id", to: "activities_events#update", as: :update_activity
  delete "events/:event_id/activities/:id", to: "activities#destroy", as: :delete_activity

  resources :organizations, only: [:show, :index, :new, :create] do
    get :invite, on: :member
  end

  # resources :events, only: [:show]
  get "/authentication/line_callback", to: "authentication#line_callback"

  resources :dashboard, only: [:index] do
    collection do
      get :owned_events
      get :collaborated_events
    end
  end
end
