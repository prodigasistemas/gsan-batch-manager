module ProcessosHelper
  def active?(situacao, situacao_selecionada)
    situacao == situacao_selecionada ? "active" : ""
  end

  def calcula_percentual_atividade(atividade)
    return 0 unless atividade

    total = atividade.total_itens
    processados = atividade.itens_processados
    return 0 if total.blank? or processados.blank?

    ((processados / total.to_f) * 100).ceil
  end
end
