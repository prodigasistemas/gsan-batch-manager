class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :carrega_situacoes

  def carrega_situacoes
    @situacoes = ProcessoSituacao.all.map(&:descricao)
  end
end
