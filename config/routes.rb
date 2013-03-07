require 'resque/server'

LocalRead::Application.routes.draw do
  get "issues/show"

  get "issues/index"

  devise_for :subscribers,
             :controllers => { :confirmations => "subscribers/confirmations"}

  post "/", :to => 'home#signup', :as => :signup
  post "/canvas/", :to => 'canvas#index', :as => :canvas
  get "/canvas/", :to => 'canvas#index', :as => :canvas
  post "/canvas/invite", :to =>'canvas#invite', :as => :fb_invite
  get "/canvas/invite", :to =>'canvas#invite', :as => :fb_invite

  get "/signup", :to => 'home#dead_signup', :as => :thanks
  get "/confirmed", :to => "home#confirmed", :as => :confirmed
  get "/unsubscribe", :to => "home#unsubscribe", :as => :unsubscribe
  get "/resubscribe", :to => "home#resubscribe", :as => :resubscribe

  get "/vancouver", :to => 'home#city', :as => :city, :lat =>  "49.261226", :lng => "-123.1139268"

  match '/vanitystats(/:action(/:id(.:format)))', :controller => :vanity


  match '/s/:id', :controller => :shortened_urls, :action => :show, :as => :shortener
  #match '/s/:id', :to => "shortened_urls#show", :as => :shortener

  #if Rails.env.development?
    mount WeeklyMailer::Preview => 'mail_view'
  #end

  resources :cities, :only => [:show] do
    resources :issues
  end

  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')
  match 'signout', to: 'sessions#destroy', as: 'signout'

  mount Resque::Server, :at => "/resque"

  root :to => "home#index"

end
