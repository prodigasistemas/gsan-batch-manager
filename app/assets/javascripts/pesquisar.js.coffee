# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $("#processos-search").autocomplete({source: '/pesquisar/processos.json'})
  $("#novo-processo-search").autocomplete({source: '/pesquisar/processos.json'})
  $("#usuarios-search").autocomplete({source: '/pesquisar/usuarios.json'})
  $("#situacoes-search").autocomplete({source: '/pesquisar/situacoes.json'})
