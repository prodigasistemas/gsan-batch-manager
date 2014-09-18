GsanBatchManager::Application.routes.draw do

  resource :processos, only: :none do
    get :filtrar
    post :configura
  end

  resources :processos, only: [:index, :show, :create]

  namespace :admin do
    resources :processos, only: [:index, :update]
  end

  resource :pesquisar, only: :none, controller: 'pesquisar' do
    get :processos
    get :usuarios
    get :situacoes
  end

  post :novo_batch, controller: :faturamento

  root to: "processos#index"
end
