Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  scope '(:locale)', :locale => /en|de|fr/ do
    root 'homepage#index'

    post   'login'   => 'sessions#create'
    delete 'logout'  => 'sessions#destroy'

    get 'import/new' => 'import#new'
    get 'import/template' => 'import#template'
    post 'import' => 'import#create'

    resources :enterprises

    resources :internships do
      member do
        patch 'authorize_internship'
        patch 'validate'
      end
    end

    namespace :users do
      resources :administrators
      resources :program_directors
    end
    resources :users
    resources :study_programs
    resources :title_translations
    resources :titles
    resources :towns
    resources :people
    resources :students
    resources :diplomas
  end
end
