Rails.application.routes.draw do

  root "articles#index"
  resources :articles do
    collection do
      get :about
      get :contact
      post :send_message
    end
  end

  #------  admin routes start ----
  namespace :admin do
    resources :tags, :categories,:articles
    resources :articles do
      collection do
        post :view
      end
    end
  end
  #------ admin routes end ----
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # make sure this rule is the last one
  get '*path' => proc { |env| Rails.env.development? ? (raise ActionController::RoutingError, %{No route matches "#{env["PATH_INFO"]}"}) : ApplicationController.action(:render_not_found).call(env) }
end
