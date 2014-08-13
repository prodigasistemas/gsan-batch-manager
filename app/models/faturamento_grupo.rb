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
end
