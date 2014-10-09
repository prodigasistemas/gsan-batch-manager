class ProcessoSituacao < ActiveRecord::Base
  self.table_name='batch.processo_situacao'
  self.primary_key='prst_id'

  SITUACAO = {
    em_processamento: 1,
    concluido: 2,
    em_espera: 3,
    agendado: 4,
    concluido_com_erro: 6,
    cancelado: 7,
    em_fila: 10,
    reiniciado: 11
  }

  has_many :processos_iniciados, class_name: 'ProcessoIniciado', foreign_key: 'prst_id'

  alias_attribute 'id', 'prst_id'
  alias_attribute 'descricao', 'prst_dsprocessosituacao'
  alias_attribute 'abreviacao', 'prst_dsabreviado'
  alias_attribute 'ultima_alteracao', 'prst_tmultimaalteracao'
end
