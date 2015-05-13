class ProcessoIniciado < ActiveRecord::Base
  self.table_name='batch.processo_iniciado'
  self.primary_key='proi_id'

  before_create :generate_id

  belongs_to :usuario, class_name: 'Usuario', foreign_key: 'usur_id'
  belongs_to :processo, class_name: 'Processo', foreign_key: 'proc_id'
  belongs_to :processo_pai, class_name: 'ProcessoIniciado', foreign_key: 'proi_id'
  belongs_to :situacao, class_name: 'ProcessoSituacao', foreign_key: 'prst_id'

  has_many :parametros, class_name: "ProcessoParametro", foreign_key: 'proi_id'
  has_many :atividades, class_name: "ControleProcessoAtividade", foreign_key: 'proi_id'

  alias_attribute 'id', 'proi_id'
  alias_attribute 'precedente', 'proi_idprecedente'
  alias_attribute 'agendamento', 'proi_tmagendamento'
  alias_attribute 'hora_inicio', 'proi_tminicio'
  alias_attribute 'hora_termino', 'proi_tmtermino'
  alias_attribute 'hora_comando', 'proi_tmcomando'
  alias_attribute 'ultima_alteracao', 'proi_tmultimaalteracao'
  alias_attribute 'grupo', 'proi_nngrupo'
  alias_attribute 'prioridade', 'proi_prioridade'

  paginates_per 20

  def iniciar_atividades total_itens
      self.processo.atividades.each do |atividade|
        controle = atividade.controle_atividades.build
        controle.configura_atividade self, atividade, total_itens
        controle.save
      end
  end

  def reiniciar (atividades)
    self.transaction do
      situacao_reiniciado = ProcessoSituacao.find(ProcessoSituacao::SITUACAO[:reiniciado])
      self.situacao = situacao_reiniciado
      atividades = self.atividades if atividades.empty?
      atividades.each do |atividade|
        atividade.situacao = situacao_reiniciado.id
        atividade.itens_processados = 0
        if not atividade.save
          return false
        end
      end

      save
    end
  end

  def cancelar
    self.situacao = ProcessoSituacao.find(ProcessoSituacao::SITUACAO[:cancelado])
    self.save
  end

  def nome
    processo.nome
  end

  def nome_usuario
    usuario.nome
  end

  def concluido?
    situacao.descricao == "CONCLUIDO"
  end

  def em_processamento?
    situacao.descricao == "EM PROCESSAMENTO"
  end

  def parado?
    ["CONCLUIDO", "CONCLUIDO COM ERRO", "EXECUCAO CANCELADA", "REINICIADO"].include? situacao.descricao
  end

  def atividades_exibidas
    atividades.joins(:processo_atividade).where("processo_atividade.exibiremtela = 1").order("ordemexecucao")
  end

  class << self
    def em_espera
      joins(:situacao).where("processo_situacao.prst_dsprocessosituacao = 'EM ESPERA'")
    end

    def em_processamento
      joins(:situacao).where("processo_situacao.prst_dsprocessosituacao = 'EM PROCESSAMENTO'")
    end

    def concluido
      joins(:situacao).where("processo_situacao.prst_dsprocessosituacao = 'CONCLUIDO'")
    end

    def agendado
      joins(:situacao).where("processo_situacao.prst_dsprocessosituacao = 'AGENDADO'")
    end

    def aguard_autorizacao
      joins(:situacao).where("processo_situacao.prst_dsprocessosituacao = 'AGUARD. AUTORIZACAO'")
    end

    def execucao_cancelada
      joins(:situacao).where("processo_situacao.prst_dsprocessosituacao = 'EXECUCAO CANCELADA'")
    end

    def concluido_com_erro
      joins(:situacao).where("processo_situacao.prst_dsprocessosituacao = 'CONCLUIDO COM ERRO'")
    end

    def inicio_a_comandar
      joins(:situacao).where("processo_situacao.prst_dsprocessosituacao = 'INICIO_A_COMANDAR'")
    end

    def reiniciado
      joins(:situacao).where("processo_situacao.prst_dsprocessosituacao = 'REINICIADO'")
    end

    def todos
      joins(:situacao)
    end
  end

  private

  def generate_id
    result = ProcessoIniciado.connection.select_value("select nextval('batch.seq_processo_iniciado')")
    self.id = result
  end
end
