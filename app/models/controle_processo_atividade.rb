class ControleProcessoAtividade < ActiveRecord::Base
  self.table_name = 'batch.controle_processo_atividade'

  before_create :generate_id


  belongs_to :processo_atividade, class_name: 'ProcessoAtividade', foreign_key: 'proa_id'
  belongs_to :processo_iniciado, class_name: 'ProcessoIniciado', foreign_key: 'proi_id'

  alias_attribute "total_itens", "totalitens"
  alias_attribute "itens_processados", "itensprocessados"

  def descricao
    return "" unless processo_atividade
    processo_atividade.descricao
  end

  def configura_atividade processo_iniciado, processo_atividade, total_itens
    self.processo_iniciado = processo_iniciado
    self.situacao = ProcessoSituacao.find(ProcessoSituacao::SITUACAO[:em_espera]).id
    self.total_itens = total_itens 
    self.total_itens ||= 1 
    self.itens_processados = 0
  end

  private

  def generate_id
    result = ControleProcessoAtividade.connection.select_value("select nextval('batch.seq_controle_processo_atividade')")
    self.id = result
  end  
end
