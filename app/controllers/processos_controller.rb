class ProcessosController < ApplicationController
  def index
    @title = params[:situacao] unless params[:situacao].blank?
    @processos = ProcessoIniciado.send(@title.downcase.gsub(" ", "_").gsub("\.", "")).page params[:page]
  end
end
