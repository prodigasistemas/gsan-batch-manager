class ProcessoTipo < ActiveRecord::Base
  self.table_name='batch.processo_tipo'
  self.primary_key='prtp_id'

  alias_attribute 'id', 'prtp_id'
  alias_attribute 'nome', 'prtp_dsprocessotipo'
end
