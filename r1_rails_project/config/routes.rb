Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/hello', to: 'request#create_post'
  get '/ping', to: 'request#create_get'
end
