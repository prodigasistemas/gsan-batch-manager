class PesquisarController < ApplicationController
  def processos
    params[:term] = '' if params[:term].blank?
    @processos = Processo.where("proc_dsprocesso ILIKE ?", "%#{params[:term]}%")
    respond_to do |format|
      format.json {
        render json: @processos.map(&:nome)
      }
    end
  end

  def usuarios
    params[:term] = '' if params[:term].blank?
    @usuarios = Usuario.where("usur_nmusuario ILIKE ?", "%#{params[:term]}%")
    respond_to do |format|
      format.json {
        render json: @usuarios.map(&:nome)
      }
    end
  end
end
