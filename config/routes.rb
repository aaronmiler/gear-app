WeatherOrNot::Application.routes.draw do
  resources :frontend, :path => "/" do
  	match :results, :on => :collection, :via => ['post','get']
  	get :multiple_results, :on => :collection
  end

end
