class Rota < ActiveRecord::Base

  self.table_name='micromedicao.rota'
  self.primary_key='rota_id'

  alias_attribute "id", "rota_id"
  alias_attribute "faturamento_grupo", "ftgr_id"
  alias_attribute "setor_comercial", "stcm_id"
  alias_attribute "codigo_rota", "rota_cdrota"
  alias_attribute "indicador_uso", "rota_icuso"

  IndicadorUso = {
    ativado: 1,
    desativado: 2
  }

  belongs_to :setor_comercial, class_name: 'SetorComercial', foreign_key: 'stcm_id'

  scope :todas_do_grupo, ->(grupo) { where(ftgr_id: grupo) }

  def self.rota_pertence_ao_grupo?(rota_id, grupo_id)
    begin
      rota = self.find(rota_id)
      rota.faturamento_grupo == grupo_id.to_i
    rescue
      false
    end
  end
end
