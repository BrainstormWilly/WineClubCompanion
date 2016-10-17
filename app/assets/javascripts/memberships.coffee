# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

checkIds = ->
  if $("#membership_club_id").val() and $("#membership_user_id").val()
    $(".add_membership").attr('disabled',false)
  else
    $(".add_membership").attr('disabled','disabled')

$('.memberships.new').ready ->
  $(document).on 'click', 'a.clubs', (e) ->
    e.preventDefault()
    $("#club").val( $(this).data("name") )
    $("#membership_club_id").val( $(this).data("id") )
    checkIds()

  $(document).on 'click', 'a.members', (e) ->
    e.preventDefault()
    $("#member").val( $(this).data("name") )
    $("#membership_user_id").val( $(this).data("id") )
    checkIds()

  $("#club").val("Select Club")
  $("#member").val("Select Member")
  $(".add_membership").attr('disabled','disabled')

  # $(".clubs").click(e) ->
  #   e.preventDefault()
  #   $("#club").val( $(this).data("name") )
  #   $("#membership_club_id").val( $(this).data("id") )
  # $(".members").click ->
  #   $("#member").val( $(this).data("name") )
  #   $("#membership_member_id").val( $(this).data("id") )
