# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$('#menutabs a').click (e) ->
  e.preventDefault()
  $(this).tab('show')

$('#datetimepicker1').datetimepicker => language: 'pt-BR'
$('#datetimepicker2').datetimepicker => language: 'pt-BR'
