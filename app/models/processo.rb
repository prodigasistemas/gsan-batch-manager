class Processo < ActiveRecord::Base
  self.table_name='batch.processo'
  self.primary_key='proc_id'

  has_many :processos_iniciados, class_name: 'ProcessoIniciado', foreign_key: 'proc_id'

  alias_attribute "nome", "proc_dsprocesso"

  def inicia_processo params={}
    self.transaction do
      processo_iniciado = {
        grupo: params[:grupo],
        ultima_alteracao: Time.now,
        usuario: Usuario.first,
        situacao: ProcessoSituacao.find(3) # EM ESPERA
      }

      novo_processo = processos_iniciados.build processo_iniciado
      novo_processo.save!

      novo_processo.parametros << ProcessoParametro.new(nome: "idRota", valor: params[:rota])
      novo_processo.parametros << ProcessoParametro.new(nome: "anoMesFaturamento", valor: params[:ano_mes_referencia])

      novo_processo.save!
    end
  end
end
