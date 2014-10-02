class ProcessosController < ApplicationController

  before_action :get_processos, except: [:show]

  def index
  end

  def show
    @processo = ProcessoIniciado.find(params[:id])
  end

  def new
  end

  def configura
  end

  def filtrar
    begin
      @processos = @processos.joins(:processo).where("processo.proc_dsprocesso LIKE ?", "%#{params[:processo]}%") unless params[:processo].blank?
      @processos = @processos.joins(:usuario).where("usuario.usur_nmusuario LIKE ?", "%#{params[:usuario]}%") unless params[:usuario].blank?
      @processos = @processos.where("processo_iniciado.proi_nngrupo = ?", params[:grupo]) unless params[:grupo].blank?
      @processos = @processos.where("processo_iniciado.proi_tminicio >= ?", params[:data_processo_inicio]) unless params[:data_processo_inicio].blank?
      @processos = @processos.where("processo_iniciado.proi_tmtermino <= ?", params[:data_processo_final]) unless params[:data_processo_final].blank?

      @total = @processos.count
      @processos.page params[:page]

      render :index
    rescue => e
      logger.warn "Problemas nos parâmetros: #{params} - #{e}"

      flash[:error] = "Problemas para executar a sua pesquisa, certifique-se que os parâmetros estão corretos"
      redirect_to root_path
    end
  end

  private

  def get_processos
    @filtros = params
    @filtros[:situacao] = "EM PROCESSAMENTO" if @filtros[:situacao].blank?

    metodo_situacao = @filtros[:situacao].downcase.strip.gsub(" ", "_").gsub("[\.]", "")
    @processos = ProcessoIniciado.send(metodo_situacao).page params[:page]
    @total = @processos.count
  end
end
