class ProcessoAtividade < ActiveRecord::Base
  self.table_name = 'batch.processo_atividade'

  has_many :controle_atividades, class_name: "ControleProcessoAtividade", foreign_key: 'proa_id'  
end
