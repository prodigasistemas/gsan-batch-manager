class Processo < ActiveRecord::Base
  self.table_name='batch.processo'
  self.primary_key='proc_id'

  belongs_to :periodicidade, class_name: 'ProcessoTipo', foreign_key: 'prtp_id'
  has_many :processos_iniciados, class_name: 'ProcessoIniciado', foreign_key: 'proc_id'

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

  def self.pesquisar_grupo_cronograma(grupo)

    if grupo.nil?
      grupo = FaturamentoGrupo.all  
      @grupos = []

      grupo.each do |g|
        cronograma = FaturamentoGrupoCronogramaMensal.joins(:faturamento_grupo).where('ftgr_id'=>g.id, 'ftcm_amreferencia' => g.ftgr_amreferencia)

        if not cronograma.empty?
          @grupos << g
        end
      end

      @grupos = @grupos.sort_by {|fg| fg.id }
    else
      cronograma = FaturamentoGrupoCronogramaMensal.joins(:faturamento_grupo).where('ftgr_id'=>grupo.id, 'ftcm_amreferencia' => grupo.ftgr_amreferencia)      
      if not cronograma.empty?
          @grupos << grupo
        end
    end

    @grupos
  end
end
