module ProcessosHelper
  def active?(situacao, situacao_selecionada)
    situacao == situacao_selecionada ? "active" : ""
  end
end
