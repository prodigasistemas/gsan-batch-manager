class ProcessoAtividade < ActiveRecord::Base
  self.table_name = 'batch.processo_atividade'

  alias_attribute 'processa_varios_itens', 'processavariositens'

  has_many :controle_atividades, class_name: "ControleProcessoAtividade", foreign_key: 'proa_id'  
end
