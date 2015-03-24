class ArquivoTextoRoteiroEmpresa < ActiveRecord::Base
  self.table_name='micromedicao.arquivo_texto_rot_empr'
  self.primary_key='txre_id'

  belongs_to :localidade, class_name: 'Localidade', foreign_key: 'loca_id'
  belongs_to :faturamento_grupo, class_name: 'FaturamentoGrupo', foreign_key: 'ftgr_id'
  belongs_to :rota, class_name: 'Rota', foreign_key: 'rota_id'

  alias_attribute "id", "txre_id"
  alias_attribute "ano_mes_referencia", "txre_amreferencia"

end