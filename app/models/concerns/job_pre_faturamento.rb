class JobPreFaturamento

  PARAMETROS = {
    "idGrupoFaturamento" => :grupo,
    "anoMesFaturamento" => :ano_mes_referencia,
    "vencimentoContas" => :vencimento_contas,
    "agendamento" => :agendamento,
    "idsRota" => :rotas
  }

  attr_accessor :id_rota, :localidade, :setor, :grupo, :rota, :ano_mes_referencia, :agendamento, :periodicidade, :processo, :vencimento_contas

  def initialize processo, params
    @processo = processo
    @grupo = params[:grupo]
    @ano_mes_referencia = params[:ano_mes_referencia]
    @agendamento = params[:agendamento]
    @periodicidade = params[:periodicidade]
    @vencimento_contas = params[:vencimento_contas]
    @localidade = (params[:localidade] == "0" or params[:localidade] == "" or params[:localidade].nil?) ? nil : params[:localidade]
    @setor = (params[:setor] == "0" or params[:setor] == "" or params[:setor].nil?) ? nil : params[:setor]
    @rota = (params[:id_rota] == "0" or params[:id_rota] == "" or params[:id_rota].nil?) ? nil : Rota.find(params[:id_rota])
  end

  def inicia_processo
    processo.transaction do
      return false unless processo_valido?

      novo_processo_iniciado = processo.processos_iniciados.build processo_iniciado_params
      novo_processo_iniciado.save!

      PARAMETROS.keys.each do |parametro|
        novo_processo_iniciado.parametros << ProcessoParametro.new(nome: parametro, valor: self.send(PARAMETROS[parametro]))
      end

      novo_processo_iniciado.save!

      novo_processo_iniciado
    end
  end

  private

  def rotas
    rotas = []

    if not rota.nil?
      rotas << @rota.id
    else
      if not @setor.nil?
        rotas = Rota.joins(setor_comercial: :localidade).where(:localidade => {:loca_id => @localidade}, :stcm_id => @setor, :ftgr_id => @grupo).map(&:id)
      elsif not @localidade.nil?
        rotas = Rota.joins(setor_comercial: :localidade).where(:localidade => {:loca_id => @localidade},  :ftgr_id => @grupo).map(&:id)  
      else
        rotas = Rota.todas_do_grupo(@grupo).map(&:id)
      end
    end

    # if rota.nil?
    #   if @localidade.nil?
    #     rotas = Rota.todas_do_grupo(@grupo)
    #   elsif @setor.nil?
    #     rotas = Rota.joins(setor_comercial: :localidade).where(:localidade => {:loca_id => @localidade},  :ftgr_id => @grupo).map(&:id)
    #   else
    #     rotas = Rota.joins(setor_comercial: :localidade).where(:localidade => {:loca_id => @localidade}, :stcm_id => @setor, :ftgr_id => @grupo).map(&:id)
    #   end
    # else
    #   rotas << @rota.id
    # end

    rotas.to_s.gsub(/\[|\]/, "")
  end

  def processo_iniciado_params
    processo_iniciado = {
      grupo: @grupo,
      ultima_alteracao: Time.now,
      usuario: Usuario.first, # Recuperar o Usuário
      situacao: ProcessoSituacao.find(ProcessoSituacao::SITUACAO[:concluido]),
      agendamento: @agendamento,
      prioridade: @processo.prioridade
    }

    processo_iniciado[:situacao] = ProcessoSituacao.find(ProcessoSituacao::SITUACAO[:agendado]) if not @agendamento.blank?

    processo_iniciado
  end

  def processo_valido?
    @processo.errors.add(:grupo, "Grupo de faturamento não existe.") unless FaturamentoGrupo.existe_grupo? @grupo

    if not @rota.blank?
      @processo.errors.add(:rota, "Grupo de faturamento não possui a Rota indicada.") unless Rota.rota_pertence_ao_grupo?(@rota.id, @grupo)
    end

    return false if @processo.errors.any?

    true
  end
end
