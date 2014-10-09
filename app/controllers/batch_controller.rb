class BatchController < ApplicationController
  def inserir_batch
    processo = Processo.where("proc_dsprocesso ILIKE ?", params[:processo]).first
    processo_iniciado = processo.inicia_processo params
    if processo_iniciado
      flash[:notice] = "O processo foi inserido com sucesso!"
    else
      flash[:error] = "<p>Erro ao inserir o processo #{params[:processo]}:"
      flash[:error].concat("<ul>")
      processo.errors.messages.values.each do |error_messages|
        flash[:error].concat("<li>#{error_messages.first}</li>")
      end
      flash[:error].concat("</ul></p>")
    end

    redirect_to processo_path(processo_iniciado.id)
  end
end
