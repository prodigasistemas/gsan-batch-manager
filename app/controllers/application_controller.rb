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
    if not session[:usuario].present?
      render :template => 'error_pages/acesso_negado', :status => :forbidden
    end
  end

  def token_valid? usuario, token
    token_batch_manager = gerar_token(usuario)
    if token == token_batch_manager
      session[:usuario] = usuario
      redirect_to new_processo_path
    else
      session[:usuario] = nil
      render :template => 'error_pages/acesso_negado', :status => :forbidden
    end
  end

  protected

  def gerar_token(usuario)
    if usuario.blank?
      data_hora = Time.now.strftime("%Y-%m-%d-%H")
		  md5(data_hora)
    else
      data_hora = Time.now.strftime("%Y-%m-%d-%H")
		  md5(usuario+data_hora)
    end
	end

  private

  def md5(s)
  	Digest::MD5.hexdigest(s)
  end

end
