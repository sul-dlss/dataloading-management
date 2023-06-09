Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  devise_for :users, skip: %i[registrations passwords sessions]
  devise_scope :user do
    get "webauth/login" => "login#login", :as => :new_user_session
    get "webauth/logout" => "devise/sessions#destroy",
      :as => :destroy_user_session,
      :via => Devise.mappings[:user].sign_out_via
  end

  resources :vendors, param: :folio_id, only: [:index, :show]

  resources :dataload_jobs, only: [:index, :show]

  root to: "dataload_jobs#index"

  namespace :api do
    # NOTE: API controller routes go in this block
    resources :dataload_jobs, only: [:index, :update]
  end
end
