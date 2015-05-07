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

  def data_vencimento
    data_vencimento = dia_vencimento.to_s + "/" + ftgr_amreferencia.to_s[4..5] + "/" + ftgr_amreferencia.to_s[0..3]
    DateTime.strptime(data_vencimento, "%d/%m/%Y")
  end

  def data_vencimento_formatada
    self.data_vencimento.blank? or self.data_vencimento.strftime("%d/%m/%Y")
  end
end
