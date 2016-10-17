# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

toggleList = (pred) ->
  if pred is "manager"
    $("#manager").parent().addClass('active')
    $("#winery").parent().removeClass('active')
    $("#managers").show()
    $("#wineries").hide()
  else
    $("#manager").parent().removeClass('active')
    $("#winery").parent().addClass('active')
    $("#managers").hide()
    $("#wineries").show()

checkIds = ->
  if $("#account_winery_id").val() and $("#account_user_id").val()
    $(".add_account").attr('disabled',false)
  else
    $(".add_account").attr('disabled','disabled')


$('.accounts.index').ready ->
  $(document).on 'click', '#manager', (e) ->
    e.preventDefault()
    toggleList('manager')

  $(document).on 'click', '#winery', (e) ->
    e.preventDefault()
    toggleList('winery')

  toggleList('winery')

$('.accounts.new').ready ->
  $(document).on 'click', 'a.wineries', (e) ->
    e.preventDefault()
    $("#winery").val( $(this).data("name") )
    $("#account_winery_id").val( $(this).data("id") )
    checkIds()

  $(document).on 'click', 'a.managers', (e) ->
    e.preventDefault()
    $("#manager").val( $(this).data("name") )
    $("#account_user_id").val( $(this).data("id") )
    checkIds()

  $("#winery").val("Select Winery")
  $("#manager").val("Select Manager")
  $(".add_account").attr('disabled','disabled')
