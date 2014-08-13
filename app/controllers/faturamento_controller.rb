class FaturamentoController < ApplicationController
  def gerar_dados_leitura
    processo = Processo.where("proc_dsprocesso ILIKE ?", params[:processo]).first
    if processo.inicia_processo params
      flash[:notice] = "O processo foi inserido com sucesso!"
    else
      flash[:error] = "<p>Erro ao inserir o processo #{params[:processo]}:"
      flash[:error].concat("<ul>")
      processo.errors.messages.values.each do |error_messages|
        flash[:error].concat("<li>#{error_messages.first}</li>")
      end
      flash[:error].concat("</ul></p>")
    end

    redirect_to root_path
  end
end
