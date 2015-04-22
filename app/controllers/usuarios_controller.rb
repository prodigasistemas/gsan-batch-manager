class UsuariosController < ApplicationController

	skip_before_filter :verify_authenticity_token, :only => [:autenticar_usuario]
	skip_before_filter :verifica_usuario

	def autenticar_usuario
		redirect_to new_processo_path and return if session[:usuario].present?

		token_valid? params[:usuario], params[:token]
	end

	def logout
	  reset_session
    redirect_to root_path
  end
end
