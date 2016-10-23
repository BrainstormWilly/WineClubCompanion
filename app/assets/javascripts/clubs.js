
function toggleClubsFilter(sort){
  if( sort == "club" ){
    $("#clubs").show();
    $("#wineries").hide();
  }else{
    $("#clubs").hide();
    $("#wineries").show();
  }
}

$(document).on('turbolinks:load', function(e){
  $('.wineries').unbind('click');
  $('.filters').unbind('click');

  if( $(e.target.body).hasClass('clubs new') ){
    $('.wineries').bind('click', function(e){
      e.preventDefault();
      $("#club_winery_name").text($(e.target).data('name'));
      $("#club_winery_id").val($(e.target).data('id'));
    });
  }else if ($(e.target.body).hasClass('clubs index')) {
    $('.filters').bind('click', function(e){
      e.preventDefault();
      $(".filters").parent().removeClass('active')
      $(e.target).parent().addClass('active');
      toggleClubsFilter($(e.target).data('filter'));
    });

    $("a[data-filter='club']").parent().addClass('active');
    toggleClubsFilter('club');
  }

});
