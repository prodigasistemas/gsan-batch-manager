class UsuariosController < ApplicationController

	skip_before_filter :verify_authenticity_token, :only => [:autenticar_usuario]
	skip_before_filter :verifica_usuario

	# Metodo utilizado para integrar o GSAN com o Batch Manager
	# Os parametros(usuario e token) sao enviados por POST
	def autenticar_usuario
		
		usuario = params[:usuario]
  	token_gsan = params[:token]

  	if (usuario.nil? || token_gsan.nil?) && session[:usuario].nil?
  		render :template => 'error_pages/acesso_negado', :status => :forbidden
  	elsif (!usuario.nil? && !token_gsan.nil?)
  		data_hora = Time.now.strftime("%Y-%m-%d-%H")
	  	token_batch_manager = md5(usuario+data_hora)
	  	# binding.pry
	  	if token_gsan != token_batch_manager
	  		render :template => 'error_pages/acesso_negado', :status => :forbidden
	  		session[:usuario] = nil
	  	else
	  		session[:usuario] = usuario
	  		redirect_to new_processo_path
	  	end
  	end
	end

	def logout
	  reset_session
    redirect_to root_path
  end

  private

  def md5(s)
  	Digest::MD5.hexdigest(s)
  end

end