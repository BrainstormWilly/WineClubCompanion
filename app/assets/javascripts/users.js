


function displayUsers(list, data){
  list.empty();
  $.each(data, function(i,v){
    list.append(
      '<a href="/users/' + v.id + '" class="list-group-item">' +
      '<h4>' + v.fullname + '</h4>' +
      '<p>' + v.email + '</p></a>'
    );
  });
}


$(document).on('turbolinks:load', function(e){


	if( $(e.target.body).hasClass('users index') ){
	    $("#search_users_members").submit(function(e){
	      e.preventDefault();
	      $.post("/api/v1/members/search", {"q": $("#search_users_members input[type='text']").val()})
	      .done(function(data){
	      	displayUsers($("#users_members_list"), data);
	      }).fail(function(err){
	        console.log(err);
	      }).always(function(){
	        console.log('always');
	      });
	    });
      $("#search_users_managers").submit(function(e){
	      e.preventDefault();
	      $.post("/api/v1/managers/search", {"q": $("#search_users_managers input[type='text']").val()})
	      .done(function(data){
	      	displayUsers($("#users_managers_list"), data);
	      }).fail(function(err){
	        console.log(err);
	      }).always(function(){
	        console.log('always');
	      });
	    });
	    $.post("/api/v1/members/search", {"q": ""})
	      .done(function(data){
	      	displayUsers($("#users_members_list"), data);
	      }).fail(function(err){
	        console.log(err);
	      }).always(function(){
	        console.log('always');
	      });
        $.post("/api/v1/managers/search", {"q": ""})
  	      .done(function(data){
  	      	displayUsers($("#users_managers_list"), data);
  	      }).fail(function(err){
  	        console.log(err);
  	      }).always(function(){
  	        console.log('always');
  	      });
  }
});
