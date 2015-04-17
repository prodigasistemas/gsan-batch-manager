class ProcessosController < ApplicationController

  before_action :get_processos, except: [:show]

  def index
  end

  def show
    @processo = ProcessoIniciado.find(params[:id])
  end

  def new
    @setores_comerciais = SetorComercial.all.sort_by {|setor| setor.id }
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
    @grupos = Processo.pesquisar_grupo_cronograma(nil).map { |g| [g.descricao, g.id] }
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

    data_vencimento = grupo_faturamento.dia_vencimento.to_s + "/" + grupo_faturamento.ftgr_amreferencia.to_s[4..5] + "/" + grupo_faturamento.ftgr_amreferencia.to_s[0..3]
    data_vencimento = DateTime.strptime(data_vencimento, "%d/%m/%Y")

    rotas = Rota.where(:ftgr_id => params[:grupo_faturamento], :rota_icuso => 1).sort_by {|rota| rota.codigo_rota }
    @rotas = rotas.map(&:codigo_rota).uniq
    @setores_comerciais = rotas.map(&:stcm_id).uniq
    @localidades = SetorComercial.where("stcm_id in (?)", @setores_comerciais).map(&:loca_id).uniq

    @localidades = @localidades.insert(0, ["Selecione a localidade (Opcional)", 0])

    respond_to do |format|
      format.js
      format.json {
        render :json => {
          :ano_mes_referencia => grupo_faturamento.ftgr_amreferencia,
          :data_vencimento => (data_vencimento.nil? && '' or data_vencimento.strftime("%d/%m/%Y"))
        }
      }
    end
  end

  def pesquisar_setores_comerciais
    @rotas = []
    if params[:localidade].empty?
      @setores_comerciais = []
    else
      @setores_comerciais = SetorComercial.joins(:rotas).where(:loca_id => params[:localidade], :rota => {:ftgr_id => params[:grupo_faturamento]})
      @setores_comerciais = @setores_comerciais.map{ |s| [s.stcm_cdsetorcomercial, s.id] }.uniq
      @setores_comerciais.insert(0, ["Selecione o setor comercial (Opcional)", 0])
    end

    respond_to do |format|
      format.js
    end
  end

  def pesquisar_rotas
    if params[:setor_comercial].empty?
      @rotas = []
    else
      @rotas = []
      localidade = SetorComercial.find(params[:setor_comercial]).localidade
      rotas = Rota.where(
        :setor_comercial => params[:setor_comercial],
        :indicador_uso => Rota::IndicadorUso[:ativado],
        :faturamento_grupo => params[:faturamento_grupo]
        ).sort_by {|rota| rota.rota_cdrota }

      rotas.each do |r|
        arquivos_gerados = ArquivoTextoRoteiroEmpresa.where(rota_id: r.id, ano_mes_referencia: params[:ano_mes_referencia], loca_id: localidade.id, ftgr_id: params[:faturamento_grupo])

        if not arquivos_gerados.empty?
          if (1..2).include?(arquivos_gerados.map(&:sitl_id)[0])
            @rotas << r
          end
        else
          @rotas << r
        end
      end


      @rotas = @rotas.map { |r| [r.codigo_rota, r.id] }
      @rotas.insert(0, ["Selecione uma rota (Opcional)",0])

    end

    respond_to do |format|
      format.js
    end
  end

  private

  def get_processos
    @filtros = params
    @filtros[:situacao] ||= ""

    if @filtros[:situacao].empty?
      @processos = ProcessoIniciado.send("todos").page params[:page]
    else
      metodo_situacao = @filtros[:situacao].downcase.strip.gsub(" ", "_").gsub("[\.]", "")
      @processos = ProcessoIniciado.send(metodo_situacao).page params[:page]
    end

    @total = @processos.count
  end
end
