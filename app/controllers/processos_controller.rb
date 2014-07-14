class ProcessosController < ApplicationController

  before_action :get_processos, except: [:processos]

  def index
  end

  def filtrar
    @processos = @processos.joins(:processo).where("processo.proc_dsprocesso LIKE ?", "%#{params[:processo]}%") unless params[:processo].blank?
    @processos = @processos.joins(:usuario).where("usuario.usur_nmusuario LIKE ?", "%#{params[:usuario]}%") unless params[:usuario].blank?

    render :index
  end

  private

  def get_processos
    @title = params[:situacao] unless params[:situacao].blank?
    @title ||= "AGENDADO"
    @processos = ProcessoIniciado.send(@title.downcase.gsub(" ", "_").gsub("\.", "")).page params[:page]
  end
end
