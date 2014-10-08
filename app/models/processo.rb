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
    klass = Kernel.const_get params[:processo].split(' ').map {|w| w.capitalize }.join('')
    klass.new(self, params).inicia_processo
  end

  def finaliza_processo processo_iniciado
    self.transaction do
      processo_iniciado_params = {
        ultima_alteracao: Time.now,
        usuario: Usuario.first, # Recuperar o Usuário
        situacao: ProcessoSituacao.find(3), # EM ESPERA
        prioridade: self.prioridade
      }

      novo_processo_iniciado = self.processos_iniciados.build processo_iniciado_params
      novo_processo_iniciado.save!

      novo_processo_iniciado.parametros << ProcessoParametro.new(nome: "idProcessoIniciado", valor: processo_iniciado.id)
      novo_processo_iniciado.save!
    end
  end
end
