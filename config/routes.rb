GsanBatchManager::Application.routes.draw do
  get "processos/index"

  root to: "processos#index"
end
