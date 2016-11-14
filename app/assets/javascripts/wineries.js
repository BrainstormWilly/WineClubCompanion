
function displayWineries(data){
  var t = "";
  $("#wineries_list").empty();
  $.each(data, function(i,v){
    t = '<a href="/wineries/' + v.id +'" class="list-group-item">';
    t += '<h4 class="list-group-item-heading">' + v.name + '</h4>';
    t += '<p class="list-group-item-text"><strong>Clubs: </strong>' + v.club_list + '</p>';
    t += '<p class="list-group-item-text">';
    t += v.address1 + '<br/>' + v.city + ", " + v.state + " " + v.zip;
    t += '</p></a>';
    $("#wineries_list").append(t);
  });
}


$(document).on('turbolinks:load', function(e){

  if( $(e.target.body).hasClass('wineries index') ){
    $("#search_wineries").submit(function(e){
      e.preventDefault();

      $.post("/api/v1/wineries/search", {"q": $("#search_wineries input[type='text']").val()})
      .done(function(data){
        displayWineries(data);
      }).fail(function(err){
        console.log(err);
      }).always(function(){
        console.log('always');
      });
    });


    $.post("/api/v1/wineries/search", {"q": ""})
    .done(function(data){
      displayWineries(data);
    }).fail(function(err){
      console.log(err);
    }).always(function(){
      console.log('always');
    });

  }

});
