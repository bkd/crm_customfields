ActionController::Routing::Routes.draw do |map|
  
  map.namespace :admin do |admin|
    admin.resources :customfields, :collection => { :search => :get, :auto_complete => :post, :options => :get, :redraw => :post }
  end

end
