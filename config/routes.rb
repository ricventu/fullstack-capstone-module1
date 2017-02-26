Rails.application.routes.draw do
  resources :bars, except: [:new, :edit]
  get '/ui'  => 'ui#index'
  get '/ui#' => 'ui#index'
  root "ui#index"
end
