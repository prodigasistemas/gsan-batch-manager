class ProcessoParametro < ActiveRecord::Base
  self.table_name='batch.processo_parametros'
  self.primary_key='prpr_id'

  belongs_to :processo_iniciado, class_name: 'ProcessoIniciado', foreign_key: 'proi_id'

  alias_attribute :nome, "prpr_nmparametro"
  alias_attribute :valor, "prpr_valorparametro"
end
