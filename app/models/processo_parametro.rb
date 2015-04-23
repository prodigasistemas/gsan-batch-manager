class ProcessoParametro < ActiveRecord::Base
  self.table_name='batch.processo_parametros'
  self.primary_key='prpr_id'

  TEMPORARIO = {
    sim: 1,
    nao: 2
  }

  before_create :generate_id

  belongs_to :processo_iniciado, class_name: 'ProcessoIniciado', foreign_key: 'proi_id'

  alias_attribute :nome, "prpr_nmparametro"
  alias_attribute :valor, "prpr_valorparametro"
  alias_attribute :temporario, "prpr_temporario"

  scope :percentual, -> { where(nome: "percentualProcessado") }

  private

  def generate_id
    result = ProcessoParametro.connection.select_value("select nextval('batch.seq_processo_parametros')")
    self.id = result
  end
end
