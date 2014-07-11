class Processo < ActiveRecord::Base
  self.table_name='batch.processo'
  self.primary_key='proc_id'

  has_many :processos_iniciados, class_name: 'ProcessoIniciado', foreign_key: 'proc_id'

  alias_attribute "nome", "proc_dsprocesso"
end
