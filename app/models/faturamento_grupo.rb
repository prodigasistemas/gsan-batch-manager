class FaturamentoGrupo < ActiveRecord::Base
  self.table_name='faturamento.faturamento_grupo'
  self.primary_key='ftgr_id'

  def self.existe_grupo?(grupo)
    begin
      grupo = FaturamentoGrupo.find(grupo)
      true
    rescue
      false
    end
  end

  alias_attribute 'id', 'ftgr_id'
  alias_attribute 'descricao', 'ftgr_dsfaturamentogrupo'
  alias_attribute 'descricao_abreviada', 'ftgr_dsabreviado'
  alias_attribute 'indicador_uso', 'ftgr_icuso'
  alias_attribute 'ano_mes_referencia', 'ftgr_amreferencia'
  alias_attribute 'dia_vencimento', 'ftgr_nndiavencimento'
  alias_attribute 'ultima_alteracao', 'ftgr_tmultimaalteracao'
  alias_attribute 'indicador_vencimento_mes_fatura', 'ftgr_icvencimentomesfatura'
end
