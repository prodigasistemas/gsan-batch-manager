class FaturamentoGrupoCronogramaMensal < ActiveRecord::Base
  self.table_name='faturamento.fatur_grupo_crg_mensal'
  self.primary_key='ftcm_id'

  belongs_to :usuario, class_name: 'Usuario', foreign_key: 'usur_id'
  belongs_to :faturamento_grupo, class_name: 'FaturamentoGrupo', foreign_key: 'ftgr_id'

  alias_attribute 'id', 'ftcm_id'
  alias_attribute 'ano_mes_referencia', 'ftcm_amreferencia'
  alias_attribute 'ultima_alteracao', 'ftcm_tmultimaalteracao'
end
