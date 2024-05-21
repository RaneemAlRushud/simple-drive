Rails.application.routes.draw do
  scope :v1 do
    # resources :blobs, only: [:create]
   resources :blobs, only: [:index]
    
    post '/blobs', to: 'blobs#create'
    get '/blobs/:id', to: 'blobs#show'

    post '/token', to: 'users#generate_token'
  end
end
