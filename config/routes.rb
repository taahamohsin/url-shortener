Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :url_records, only: [:create], path: 'urls'
  get 'redirect/:url', to: 'url_records#redirect'
  get 'stats/:url', to: 'url_records#stats'
end
