class ProcessoSituacao < ActiveRecord::Base
  self.table_name='batch.processo_situacao'
  self.primary_key='prst_id'

  has_many :processos_iniciados, class_name: 'ProcessoIniciado', foreign_key: 'prst_id'

  alias_attribute 'id', 'prst_id'
  alias_attribute 'descricao', 'prst_dsprocessosituacao'
  alias_attribute 'abreviacao', 'prst_dsabreviado'
  alias_attribute 'ultima_alteracao', 'prst_tmultimaalteracao'
end
