Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
    new: 'novo', edit: 'editar',
    sign_in: 'login', sign_out: 'logout', password: 'senha'
  }


  root 'projects#index'
  resources :projects, path: ''
end
