require 'digest/md5'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :verifica_usuario, :carrega_situacoes

  def carrega_situacoes
    @situacoes = ProcessoSituacao.all.map(&:descricao)
  end

  def verifica_usuario
    # binding.pry
    if session[:usuario].nil?
      render :template => 'error_pages/acesso_negado', :status => :forbidden
    end
  end

end
