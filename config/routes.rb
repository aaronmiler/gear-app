WeatherOrNot::Application.routes.draw do
  resources :frontend, :path => "/" do
  	get :results, :on => :collection
  	get :multiple_results, :on => :collection
  end

end
