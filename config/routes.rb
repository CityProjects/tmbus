Tmbus::Application.routes.draw do






  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do

      match '/test', to: 'base_api#test'

      match '/auth', to: 'base_api#auth'



      get '/routes', to: 'public_api#index'
      get '/routes/:id', to: 'public_api#route_show'


      put '/routes', to: 'write_api#route_update'


    end
  end




  get '/manage', to: 'manage/base_management#index'
  namespace :manage do
    resources :routes
  end


  root to: 'content#index'

end
