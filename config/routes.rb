GsanBatchManager::Application.routes.draw do

  resources :processos, only: [:index, :create]

  resource :processos, only: :none do
    get :filtrar
    post :configura
  end

  resource :pesquisar, only: :none, controller: 'pesquisar' do
    get :processos
    get :usuarios
    get :situacoes
  end

  post :gerar_dados_leitura, controller: :faturamento

  root to: "processos#index"
end
