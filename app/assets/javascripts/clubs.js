
function toggleClubsFilter(filter, data){
  $("#club_items").empty();
  $("#clubs_winery").removeClass('active');
  $("#clubs_club").removeClass('active');
  if( filter=="wineries" ){
    var text = "";
    $.each(data, function(i,v){
      text += "<div class=\"list-group-item\"><h4>" + v.name + "</h4>";
      $.each(v.clubs, function(ii,vv){
        text += "<a href='/clubs/" + vv.id + "' class='list-group-item'>" +
        "<h5 class='list-group-item-heading'>" + vv.name + "</h5>" +
        "<p class=''list-group-item-text'>" + vv.description + "</p>" +
        "</a>";
      });
      text += "</div>";
    });

    $("#clubs_winery").addClass('active');
  }else{
    var text = ""
    $.each(data, function(i,v){
      text += "<a href='/clubs/" + v.id + "' class='list-group-item'>" +
      "<h4 class='list-group-item-heading'>" + v.name + "</h4>" +
      "<h5 class='list-group-item-heading'>" + v.winery_name+ "</h5>" +
      "<p class=''list-group-item-text'>" + v.description + "</p>" +
      "</a>";
    });
    $("#clubs_club").addClass('active');
  }
  $("#club_items").html(text);
}

function displayNewClubWineries(data){
  var t = "";
  $("#clubs_new_wineries_list").empty();
  $.each(data, function(i,v){
    $("#clubs_new_wineries_list").append(
      '<a href class="list-group-item" data-turbolinks="false" data-id="' + v.id + '" data-name="' + v.name + '">' + v.name + '</a>'
    );
  })
}


$(document).on('turbolinks:load', function(e){

  var by_state = "";

  if( $(e.target.body).hasClass('clubs index') ){
    $("#search_clubs_new_wineries").submit(function(e){
      e.preventDefault();
      $.post("/api/v1/clubs/" + by_state, {"q": $("#search_clubs_new_wineries input[type='text']").val()})
      .done(function(data){

        toggleClubsFilter(by_state, data);
      }).fail(function(err){
        console.log(err);
      }).always(function(){
        console.log('always');
      });
    });

    $("#filter_clubs_winery").on('click', function(e){
      e.preventDefault();
      $("#search_clubs input[type='text']").val("");
      $.get("/api/v1/clubs/wineries", function(){
        by_state = "wineries";
      }).done(function(data){
        toggleClubsFilter(by_state, data);
      }).fail(function(){
        console.log("fail");
      }).always(function(){
        console.log("always");
      });
    });
    $("#filter_clubs_club").on('click', function(e){
      e.preventDefault();
      $("#search_clubs input[type='text']").val("");
      $.get("/api/v1/clubs/", function(){
        by_state = "";
      }).done(function(data){
        toggleClubsFilter(by_state, data);
      }).fail(function(){
        console.log("fail");
      }).always(function(){
        console.log("always");
      });
    });

    $.get("/api/v1/clubs", function(){
    }).done(function(data){
      toggleClubsFilter("club", data);
    }).fail(function(){
      console.log("fail");
    }).always(function(){
      console.log("always");
    });

  }else if( $(e.target.body).hasClass('clubs new') ){
    $("#search_clubs_new_wineries").submit(function(e){
      e.preventDefault();
      $.post("/api/v1/wineries/search", {"q": $("#search_clubs_new_wineries input[type='text']").val()})
      .done(function(data){
        console.log(data);
        displayNewClubWineries(data);
      }).fail(function(err){
        console.log(err);
      }).always(function(){
        console.log('always');
      });
    });
    $("#clubs_new_wineries_list").on('click', "a", function(e){
      e.preventDefault();
      $("#club_winery_id").val($(e.currentTarget).data('id'));
      $("#clubs_new_wineries_heading h5 a").text($(e.currentTarget).data('name'));
    });

    $.post("/api/v1/wineries/search", {"q": ""})
    .done(function(data){
      displayNewClubWineries(data);
    }).fail(function(err){
      console.log(err);
    }).always(function(){
      console.log('always');
    });
  }

});
