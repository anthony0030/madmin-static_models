Rails.application.routes.draw do
  namespace :madmin do
    resources :airports
    resources :countries
    resources :widgets

    root to: "dashboard#show"
  end
end
