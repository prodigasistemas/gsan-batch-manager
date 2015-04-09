GsanBatchManager::Application.routes.draw do

  resource :processos, only: :none do
    get :filtrar
    post :configura
    post :get_cronograma_info
    post :pesquisar_setores_comerciais
    post :pesquisar_rotas
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

  post :autenticar_usuario, :controller => 'usuarios', :action => 'autenticar_usuario'

  get :logout, :controller => 'usuarios', :action => 'logout'

  root to: "processos#index"
end
