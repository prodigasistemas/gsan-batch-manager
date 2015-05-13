class Processo < ActiveRecord::Base
  self.table_name='batch.processo'
  self.primary_key='proc_id'

  belongs_to :periodicidade, class_name: 'ProcessoTipo', foreign_key: 'prtp_id'
  has_many :processos_iniciados, class_name: 'ProcessoIniciado', foreign_key: 'proc_id'
  has_many :atividades, class_name: "ProcessoAtividade", foreign_key: 'proc_id'

  alias_attribute "id", "proc_id"
  alias_attribute "nome", "proc_dsprocesso"
  alias_attribute "ultima_alteracao", "proc_tmultimaalteracao"
  alias_attribute "prioridade", "proc_prioridade"
  alias_attribute "limite", "proc_limite"
  alias_attribute "arquivo_batch", "proc_nmarquivobatch"

  scope :finalizacao, -> { where(arquivo_batch: 'job_parar_batch').first }

  def inicia_processo params={}
    klass = Kernel.const_get params[:nome_batch].split('_').map {|w| w.capitalize }.join('')
    klass.new(self, params).inicia_processo
  end

  def self.pesquisar_grupo_cronograma(grupos)
    if grupos.blank?
      @grupos_cronograma = []
      grupos ||= FaturamentoGrupo.all
    end

    get_grupos_cronograma(grupos)
  end

  def self.get_grupos_cronograma(grupos)
    grupos.each do |grupo|
      @grupos_cronograma << grupo if FaturamentoGrupoCronogramaMensal.possui_faturamento_grupo?(grupo)
    end

    @grupos_cronograma.sort_by { |faturamento_grupo| faturamento_grupo.id }
  end
end
