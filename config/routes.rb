GsanBatchManager::Application.routes.draw do

  resource :processos, only: :none do
    get :filtrar
    post :configura
  end

  resources :processos

  namespace :admin do
    resources :processos, only: [:index, :update]
  end

  resource :pesquisar, only: :none, controller: 'pesquisar' do
    get :processos
    get :usuarios
    get :situacoes
  end

  post :inserir_batch, controller: :batch

  root to: "processos#index"
end
