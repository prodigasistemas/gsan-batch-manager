$( "#grupos_faturamento" ).change(function () {
  $.ajax({
    url: "/processos/get_cronograma_info",
    type: "POST",
    data: {grupo_faturamento: $('#grupos_faturamento option:selected').val()},
    dataType: 'json',
    success: function(data) {
        if (data.ano_mes_referencia) {
          $("#ano_mes_referencia").val(data.ano_mes_referencia);
          $("#ano_mes_referencia_text").val(data.ano_mes_referencia);
        }

        if (data.data_vencimento) {
          $("#vencimento_contas").val(data.data_vencimento);
        } else {
          $("#vencimento_contas").val('');
        }
    }
  });

  $.ajax({
    url: "/processos/get_cronograma_info",
    type: "POST",
    data: {grupo_faturamento: $('#grupos_faturamento option:selected').val()},
    dataType: 'script'
  });
});

$( "#localidades" ).change(function () {
  $.ajax({
    url: "/processos/pesquisar_setores_comerciais",
    type: "POST",
    data: {
      localidade: $('#localidades option:selected').val(),
      grupo_faturamento: $('#grupos_faturamento option:selected').val()},
    dataType: 'script'
  });
});

$( "#setores_comerciais" ).change(function () {
  $.ajax({
    url: "/processos/pesquisar_rotas",
    type: "POST",
    data: {
      setor_comercial: $('#setores_comerciais option:selected').val(),
      faturamento_grupo: $('#grupos_faturamento option:selected').val(),
      ano_mes_referencia: $("#ano_mes_referencia").val()
    },
    dataType: 'script'
  });
});

$(document).ready(function(){
  $('#calendario_vencimento_contas').datetimepicker({
    pickTime: false,
    language: 'pt-BR'
  });
});
