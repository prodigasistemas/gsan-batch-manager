class Rota < ActiveRecord::Base

  self.table_name='micromedicao.rota'
  self.primary_key='rota_id'

  alias_attribute "id", "rota_id"
  alias_attribute "faturamento_grupo", "ftgr_id"

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
