Rails.application.routes.draw do
  resources :themes
  resources :rooms
  
  resources :villages do
  	collection do
  	  get 'board'
  	end
  end
  
  
  
  
  get 'selectroom/index'
  # get 'rule/index'
  resources :rule do
    collection do
  	  get 'rule_detail'
  	end
  end
  
  
  get 'welcome/index'
  
  root 'welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
