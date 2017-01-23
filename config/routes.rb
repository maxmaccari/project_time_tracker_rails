Rails.application.routes.draw do
  root 'projects#index'

  devise_for :users, path: '', path_names: {
    new: 'novo', edit: 'editar',
    sign_in: 'login', sign_out: 'logout', password: 'senha'
  }

  resources :projects, path: 'projetos', path_names: {  new: 'novo', edit: 'edicao'}
end
