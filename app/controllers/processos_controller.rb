class ProcessosController < ApplicationController

  before_action :get_processos, except: [:show]

  def index
  end

  def show
    @processo = ProcessoIniciado.find(params[:id])
    parametroPercentual = @processo.parametros.percentual.first
    @percentual = parametroPercentual.valor rescue 0
  end

  def new
  end

  def update
    @processo = ProcessoIniciado.find(params[:id])
    @processo.situacao = ProcessoSituacao.find(ProcessoSituacao::SITUACAO[:reiniciado])
    if @processo.save
      flash[:notice] = "Processo reiniciado com sucesso!"
      redirect_to processo_path(@processo)
    else
      flash[:error] = "Erro ao reiniciar processo!"
      render :show
    end
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

  def destroy
    @processo = ProcessoIniciado.find(params[:id])
    @processo.situacao = ProcessoSituacao.find(ProcessoSituacao::SITUACAO[:cancelado])

    if @processo.save
      flash[:notice] = "O processo ##{@processo.id} entrou em processo de cancelamento da execução."
      redirect_to processo_path(@processo.id)
    else
      flash[:error] = "Ocorreu um erro ao tentar cancelar o processo (##{@processo.id})."
      render :show
    end
  end

  def get_cronograma_info
    grupo_faturamento = FaturamentoGrupo.find(params[:grupo_faturamento])

    cronograma_mensal_faturamento_grupo = FaturamentoGrupoCronogramaMensal.joins(:faturamento_grupo).where('ftgr_id'=>grupo_faturamento.id, 'ftcm_amreferencia' => grupo_faturamento.ftgr_amreferencia)

    if !cronograma_mensal_faturamento_grupo.empty?
      data_vencimento = grupo_faturamento.dia_vencimento.to_s + "/" + grupo_faturamento.ftgr_amreferencia.to_s[4..5] + "/" + grupo_faturamento.ftgr_amreferencia.to_s[0..3]
      data_vencimento = DateTime.strptime(data_vencimento, "%d/%m/%Y")
    end

    respond_to do |format|
      format.json { 
        render :json => {
          :ano_mes_referencia => grupo_faturamento.ftgr_amreferencia, 
          :data_vencimento => (data_vencimento.nil? && '' or data_vencimento.strftime("%d/%m/%Y"))
        } 
      }
    end
  end

  private

  def get_processos
    @filtros = params
    @filtros[:situacao] ||= "EM PROCESSAMENTO"

    metodo_situacao = @filtros[:situacao].downcase.strip.gsub(" ", "_").gsub("[\.]", "")
    @processos = ProcessoIniciado.send(metodo_situacao).page params[:page]
    @total = @processos.count
  end
end
