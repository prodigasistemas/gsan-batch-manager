GsanBatchManager::Application.routes.draw do

  resources :processos, only: [:index]

  resource :processos, only: :none do
    post :filtrar
  end

  resource :pesquisar, only: :none, controller: 'pesquisar' do
    get :processos
    get :usuarios
  end

  root to: "processos#index"
end
