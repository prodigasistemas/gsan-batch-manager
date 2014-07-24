class FaturamentoController < ApplicationController
  def gerar_dados_leitura
    processo = Processo.where("proc_dsprocesso ILIKE ?", params[:processo]).first
    if processo.inicia_processo params
      flash[:notice] = "sucesso!"
    else
      flash[:alert] = "Error!"
    end

    redirect_to root_path
  end
end
