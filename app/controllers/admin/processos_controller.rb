class Admin::ProcessosController < ApplicationController
  def index
    @processos = Processo.all.order("proc_prioridade DESC").page params[:page]
  end

  def update
    processo = Processo.find(params[:id])

    if processo.update_attributes(processo_params)
      processo.periodicidade = ProcessoTipo.find(params[:periodicidade])
      if processo.save
        flash[:notice] = "Configurações atualizadas com sucesso!"
        redirect_to admin_processos_path
      else
        flash[:error] = "Erro ao atualizar configurações!"
        redirect_to admin_processos_path
      end
    else
      flash[:error] = "Erro ao atualizar configurações!"
      redirect_to admin_processos_path
    end
  end

  private

  def processo_params
    params.require(:processo).permit([:prioridade, :limite, :arquivo_batch])
  end
end
