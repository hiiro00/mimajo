Rails.application.routes.draw do
  devise_for :users, :controllers => {
    :registrations => 'users/registrations'
   }
  
  
  resources :themes
  resources :rooms do
    	collection do
  	  get 'login'
  	  get 'list'
  	  put 'join'
  	  get 'judge'
  	  get 'room_out'
  	end
  end
  
  resources :villages do
  	collection do
  	  get 'board'
  	  put 'create'
  	  get 'modal_trigger_show'
  	  put 'resend_show_village'
  	  put 'notif_result_village'
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
