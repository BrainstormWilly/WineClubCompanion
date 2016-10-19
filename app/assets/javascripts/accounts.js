// toggleList = (pred) ->
//   console.log(pred)
//   if pred is "manager"
//     $("#manager").parent().addClass('active')
//     $("#winery").parent().removeClass('active')
//     $("#managers").show()
//     $("#wineries").hide()
//   else
//     $("#manager").parent().removeClass('active')
//     $("#winery").parent().addClass('active')
//     $("#managers").hide()
//     $("#wineries").show()
//
// checkIds = ->
//   if $("#account_winery_id").val() and $("#account_user_id").val()
//     $(".add_account").attr('disabled',false)
//   else
//     $(".add_account").attr('disabled','disabled')
//
// setNewDefaults = ->
//   $("#winery").val("Select Winery")
//   $("#manager").val("Select Manager")
//   $(".add_account").attr('disabled','disabled')

function validateAddAccountForm(){
  if( $("#account_winery_id").val() && $("#account_user_id").val() ){
    $(".add_account").attr('disabled',false);
  }else{
    $(".add_account").attr('disabled','disabled');
  }
}

function toggleAccountsFilter(sort){
  if( sort == "manager" ){
    $("#managers").show();
    $("#wineries").hide();
  }else{
    $("#managers").hide();
    $("#wineries").show();
  }
}

$(document).on('turbolinks:load', function(e){
  $('.managers').unbind('click');
  $('.wineries').unbind('click');
  $('.filters').unbind('click');

  if( $(e.target.body).hasClass('accounts index') ){
    $('.filters').bind('click', function(e){
      e.preventDefault();
      $(".filters").parent().removeClass('active')
      $(e.target).parent().addClass('active');
      toggleAccountsFilter($(e.target).data('filter'));
    });

    $("a[data-filter='winery']").parent().addClass('active');
    toggleAccountsFilter('winery');
  }else if( $(e.target.body).hasClass('accounts new') ){
    $(".add_account").attr('disabled','disabled');
    $('.managers').bind('click', function(e){
      e.preventDefault();
      $("#account_user_name").val($(e.target).data('name'));
      $("#account_user_id").val($(e.target).data('id'));
      validateAddAccountForm();
    });
    $('.wineries').bind('click', function(e){
      e.preventDefault();
      $("#account_winery_name").val($(e.target).data('name'));
      $("#account_winery_id").val($(e.target).data('id'));
      validateAddAccountForm();
    });
  }

});
