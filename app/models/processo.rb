class Processo < ActiveRecord::Base
  self.table_name='batch.processo'
  self.primary_key='proc_id'

  has_many :processos_iniciados, class_name: 'ProcessoIniciado', foreign_key: 'proc_id'

  alias_attribute "nome", "proc_dsprocesso"

  def inicia_processo params={}
    self.transaction do
      return false unless processo_valido? params

      processo_iniciado = {
        grupo: params[:grupo],
        ultima_alteracao: Time.now,
        usuario: Usuario.first,
        situacao: ProcessoSituacao.find(3) # EM ESPERA
      }

      novo_processo = processos_iniciados.build processo_iniciado
      novo_processo.save!

      rotas = []
      if params[:rota].blank?
        rotas = Rota.todas_do_grupo(params[:grupo]).map(&:id)
      else
        rotas << params[:rota]
      end

      novo_processo.parametros << ProcessoParametro.new(nome: "faturamentoGrupo", valor: params[:grupo])
      novo_processo.parametros << ProcessoParametro.new(nome: "idsRota", valor: rotas.to_s.gsub(/\[|\]/, ""))
      novo_processo.parametros << ProcessoParametro.new(nome: "anoMesFaturamento", valor: params[:ano_mes_referencia])

      novo_processo.save!

      true
    end
  end

  private

  def processo_valido?(params)
    errors.add(:grupo, "Grupo de faturamento não existe.") unless FaturamentoGrupo.existe_grupo? params[:grupo]

    if not params[:rota].blank?
      errors.add(:rota, "Grupo de faturamento não possui a Rota indicada.") unless Rota.rota_pertence_ao_grupo?(params[:rota], params[:grupo])
    end

    return false if errors.any?

    true
  end
end
