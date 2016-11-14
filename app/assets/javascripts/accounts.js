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

function displayAccounts(filter, data){
  $("#account_items").empty();
  $("#accounts_winery").removeClass('active');
  $("#accounts_manager").removeClass('active');
  if( filter=="managers" ){
    $.each(data, function(i,v){
      var text  =   "<div class=\"list-group-item\">" +
                      "<h4>" + v.fullname + "</h4>";
      $.each(v.accounts, function(ii, vv){
        text += "<a href='/accounts/" + vv.id + "' class='list-group-item'>" +
                  "<h5 class='list-group-item-heading'>" + vv.winery_name + "</h5>" +
                  "<p class=''list-group-item-heading'><strong>Clubs: </strong>" + vv.clubs + "</p>" +
                "</a>";
      });
      text += "</div>";
      $("#account_items").append(text);
    });
    $("#accounts_manager").addClass('active');

  }else{
    $.each(data, function(i,v){
      $("#account_items").append(
        "<a href='/accounts/" + v.id + "' class='list-group-item'>" +
        "<h4 class='list-group-item-heading'>" + v.winery_name + "</h4>" +
        "<h5 class='list-group-item-heading'>" + v.user_fullname + "</h5>" +
        "<p class=''list-group-item-heading'><strong>Clubs: </strong>" + v.clubs + "</p>" +
        "</a>");
    });
    $("#accounts_winery").addClass('active');
  }
}

function displayAccountWineries(data){
  $("#accounts_new_wineries_list").empty();
  $.each(data, function(i,v){
    $("#accounts_new_wineries_list").append(
      '<a href class="list-group-item" data-id="' + v.id +'" data-name="' + v.name +'">' + v.name + '</a>'
    );
  });
}

function displayAccountManagers(data){
  $("#accounts_new_managers_list").empty();
  $.each(data, function(i,v){
    $("#accounts_new_managers_list").append(
      '<a href class="list-group-item" data-id="' + v.id +'" data-name="' + v.fullname +'">' + v.fullname + '</a>'
    );
  });
}




$(document).on('turbolinks:load', function(e){
  // $('.filters').unbind('click');
  //
  if( $(e.target.body).hasClass('accounts index') ){

    var account_by_state = "";

    $("#search_accounts").submit(function(e){
	      e.preventDefault();
	      $.post("/api/v1/accounts/" + account_by_state, {"q": $("#search_accounts input[type='text']").val()})
	      .done(function(data){
	      	displayAccounts(account_by_state, data);
	      }).fail(function(err){
	        console.log(err);
	      }).always(function(){
	        console.log('always');
	      });
	    });

    $("#filter_accounts_winery").on('click', function(e){
      e.preventDefault();
      account_by_state = "";
      $.get("/api/v1/accounts/", function(){
      }).done(function(data){
        displayAccounts(account_by_state, data);
      }).fail(function(){
        console.log("fail");
      }).always(function(){
        console.log("always");
      });
    });
    $("#filter_accounts_manager").on('click', function(e){
      e.preventDefault();
      account_by_state = "managers"
      $.get("/api/v1/accounts/managers", function(){
      }).done(function(data){
        displayAccounts(account_by_state, data);
      }).fail(function(){
        console.log("fail");
      }).always(function(){
        console.log("always");
      });
    });

    $.get("/api/v1/accounts/", function(){
    }).done(function(data){
      displayAccounts(account_by_state, data);
    }).fail(function(){
      console.log("fail");
    }).always(function(){
      console.log("always");
    });

  }else if( $(e.target.body).hasClass('accounts new') ){
    $(".add_account").attr('disabled','disabled');
    $("#search_accounts_new_wineries").submit(function(e){
	      e.preventDefault();
	      $.post("/api/v1/wineries/search", {"q": $("#search_accounts_new_wineries input[type='text']").val()})
	      .done(function(data){
	      	displayAccountWineries(data);
	      }).fail(function(err){
	        console.log(err);
	      }).always(function(){
	        console.log('always');
	      });
	    });
    $("#search_accounts_new_wineries").submit(function(e){
  	      e.preventDefault();
  	      $.post("/api/v1/managers/search", {"q": $("#search_accounts_new_managers input[type='text']").val()})
  	      .done(function(data){
  	      	displayAccountManagers(data);
  	      }).fail(function(err){
  	        console.log(err);
  	      }).always(function(){
  	        console.log('always');
  	      });
  	    });
    $('#accounts_new_managers_list').on('click', 'a', function(e){
      e.preventDefault();
      $("#account_user_name").val($(e.currentTarget).data('name'));
      $("#account_user_id").val($(e.currentTarget).data('id'));
      validateAddAccountForm();
    });
    $('#accounts_new_wineries_list').on('click', 'a', function(e){
      e.preventDefault();
      $("#account_winery_name").val($(e.currentTarget).data('name'));
      $("#account_winery_id").val($(e.currentTarget).data('id'));
      validateAddAccountForm();
    });

    $.post("/api/v1/wineries/search", {"q": ""})
    .done(function(data){
      displayAccountWineries(data);
    }).fail(function(err){
      console.log(err);
    }).always(function(){
      console.log('always');
    });

    $.post("/api/v1/managers/search", {"q": ""})
    .done(function(data){
      displayAccountManagers(data);
    }).fail(function(err){
      console.log(err);
    }).always(function(){
      console.log('always');
    });

  }

});
