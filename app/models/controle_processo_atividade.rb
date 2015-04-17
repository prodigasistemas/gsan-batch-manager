class ControleProcessoAtividade < ActiveRecord::Base
  self.table_name = 'batch.controle_processo_atividade'

  belongs_to :processo_atividade, class_name: 'ProcessoAtividade', foreign_key: 'proa_id'
  belongs_to :processo_iniciado, class_name: 'ProcessoIniciado', foreign_key: 'proi_id'

  alias_attribute "total_itens", "totalitens"
  alias_attribute "itens_processados", "itensprocessados"

  def descricao
    return "" unless processo_atividade
    processo_atividade.descricao
  end
end
