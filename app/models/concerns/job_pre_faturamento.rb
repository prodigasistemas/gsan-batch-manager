class JobPreFaturamento

  PARAMETROS = {
    "idGrupoFaturamento" => :grupo,
    "idsRota" => :rotas,
    "anoMesFaturamento" => :ano_mes_referencia
  }

  attr_accessor :grupo, :rota, :ano_mes_referencia, :agendamento, :periodicidade, :processo

  def initialize processo, params
    @processo = processo
    @grupo = params[:grupo]
    @rota = params[:rota]
    @ano_mes_referencia = params[:ano_mes_referencia]
    @agendamento = params[:agendamento]
    @periodicidade = params[:periodicidade]
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
    if rota.blank?
      rotas = Rota.todas_do_grupo(@grupo).map(&:id)
    else
      rotas << @rota
    end

    rotas.to_s.gsub(/\[|\]/, "")
  end

  def processo_iniciado_params
    processo_iniciado = {
      grupo: @grupo,
      ultima_alteracao: Time.now,
      usuario: Usuario.first, # Recuperar o Usuário
      situacao: ProcessoSituacao.find(ProcessoSituacao::SITUACAO[:em_espera]),
      agendamento: @agendamento,
      prioridade: @processo.prioridade
    }

    processo_iniciado[:situacao] = ProcessoSituacao.find(ProcessoSituacao::SITUACAO[:agendado]) if @agendamento

    processo_iniciado
  end

  def processo_valido?
    @processo.errors.add(:grupo, "Grupo de faturamento não existe.") unless FaturamentoGrupo.existe_grupo? @grupo

    if not @rota.blank?
      @processo.errors.add(:rota, "Grupo de faturamento não possui a Rota indicada.") unless Rota.rota_pertence_ao_grupo?(@rota, @grupo)
    end

    return false if @processo.errors.any?

    true
  end
end
