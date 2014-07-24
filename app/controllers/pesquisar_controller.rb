class PesquisarController < ApplicationController
  def processos
    pesquisa Processo, "proc_dsprocesso", :nome
  end

  def usuarios
    pesquisa Usuario, "usur_nmusuario", :nome
  end

  def situacoes
    pesquisa ProcessoSituacao, "prst_dsprocessosituacao", :descricao
  end

  private

  def pesquisa(klass, campo, campo_retorno)
    params[:term] = '' if params[:term].blank?
    @resultados = klass.send(:where, "#{campo} ILIKE ?", "%#{params[:term]}%")
    respond_to do |format|
      format.json {
        render json: @resultados.map(&campo_retorno)
      }
    end
  end
end
