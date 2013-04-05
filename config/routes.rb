Tmbus::Application.routes.draw do






  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do

      match '/test', to: 'base_api#test'

      match '/auth', to: 'base_api#auth'



      get '/routes', to: 'routes_api#index'
      get '/routes/:tag', to: 'routes_api#show'





    end
  end


  root to: 'content#index'

end
