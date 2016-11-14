function displayMemberships(data){

	$("#memberships_list").empty();

	$.each(data, function(i,v){
  		if( v.registered ){
  			text = "<a class=\"list-group-item list-group-item-success\" href=\"/memberships/" + v.id + "\">";
  		}else{
  			text = "<a class=\"list-group-item list-group-item-danger\" href=\"/memberships/" + v.id + "\">";
  		}
  		text += "<h4 class='list-group-item-heading'>" + v.club_name + "</h4>";
  		text += "<p class='list-group-item-text'>" + v.user_fullname + "</p>";
      	text += "</a>";
      	$("#memberships_list").append(text);
    });

}

function displayClubs(filter, data){
	var t = '';
	$("#memberships_new_clubs_list").empty();
	$("#memberships_new_clubs_winery").removeClass('active');
  	$("#memberships_new_clubs_club").removeClass('active');


	$.each(data, function(i,v){
		t = '';
		if(filter=="wineries"){
			t += "<div class='list-group-item'><h4>" + v.name + "</h4>";
		    $.each(v.clubs, function(ii,vv){
		        t += "<a href data-id='" + vv.id + "' data-name='" + vv.name + "' class='memberships_new_club_items list-group-item'>" +
		        "<h5 class='list-group-item-heading'>" + vv.name + "</h5></a>";
	      	});
		    t += "</div>";
		}else{
			t = "<a href class='memberships_new_club_items list-group-item' data-id='" + v.id + "' data-name='" + v.name + "'>" + v.name + " <small>(" + v.winery_name + ")</small></a>";
		}
		$("#memberships_new_clubs_list").append(t);
	});

	if(filter=="wineries"){
		$("#memberships_new_clubs_winery").addClass('active');
	}else{
		$("#memberships_new_clubs_club").addClass('active');
	}
}

function displayMembers(data){
	var t = '';
	$("#memberships_new_members_list").empty();
	$.each(data, function(i,v){
		t = "<a href class='list-group-item' data-id='" + v.id + "' data-name='" + v.fullname + "'>" + v.fullname + "</a>";
		$("#memberships_new_members_list").append(t);
	});
}



$(document).on('turbolinks:load', function(e){


	if( $(e.target.body).hasClass('memberships index') ){
	    $("#search_memberships").submit(function(e){
	      e.preventDefault();
	      $.post("/api/v1/memberships/search", {"q": $("#search_memberships input[type='text']").val()})
	      .done(function(data){
	      	displayMemberships(data);
	      }).fail(function(err){
	        console.log(err);
	      }).always(function(){
	        console.log('always');
	      });
	    });

	    $.post("/api/v1/memberships/search", {"q": ""})
	      .done(function(data){
	      	displayMemberships(data);
	      }).fail(function(err){
	        console.log(err);
	      }).always(function(){
	        console.log('always');
	      });
	}

	if( $(e.target.body).hasClass('memberships new') ){

		var club_by_state = ""

		$("#search_memberships_new_clubs").submit(function(e){
	      e.preventDefault();
	      $.post("/api/v1/clubs/" + club_by_state, {"q": $("#search_memberships_new_clubs input[type='text']").val()})
	      .done(function(data){
	      	displayClubs(club_by_state, data);
	      }).fail(function(err){
	        console.log(err);
	      }).always(function(){
	        console.log('always');
	      });
	    });

	    $("#search_memberships_new_members").submit(function(e){
	      e.preventDefault();
	      $.post("/api/v1/members/search", {"q": $("#search_memberships_new_members input[type='text']").val()})
	      .done(function(data){
	      	displayMembers(data);
	      }).fail(function(err){
	        console.log(err);
	      }).always(function(){
	        console.log('always');
	      });
	    });

	    $("#filter_memberships_new_clubs_winery").on('click', function(e){
	      e.preventDefault();
	      club_by_state = "wineries";
	      $("#search_memberships_new_clubs input[type='text']").val("");
	      $.get("/api/v1/clubs/wineries", function(){
	      }).done(function(data){
	        displayClubs(club_by_state, data);
	      }).fail(function(){
	        console.log("fail");
	      }).always(function(){
	        console.log("always");
	      });
	    });

	    $("#filter_memberships_new_clubs_club").on('click', function(e){
	      e.preventDefault();
	      club_by_state = "";
	      $("#search_memberships_new_clubs input[type='text']").val("");
	      $.get("/api/v1/clubs/", function(){
	      }).done(function(data){
	        displayClubs(club_by_state, data);
	      }).fail(function(){
	        console.log("fail");
	      }).always(function(){
	        console.log("always");
	      });
	    });

	    $("#memberships_new_clubs_list").on('click', "a", function(e){
	    	e.preventDefault();
				$("#membership_club_id").val($(e.currentTarget).data("id"));
				$("#club").val($(e.currentTarget).data("name"));
	    });

	    $("#memberships_new_members_list").on('click', "a", function(e){
	    	e.preventDefault();
				$("#membership_user_id").val($(e.currentTarget).data("id"));
				$("#member").val($(e.currentTarget).data("name"));
	    });

	    $.get("/api/v1/clubs/", function(){
	        by_state = "";
	      }).done(function(data){
	        displayClubs(by_state, data);
	      }).fail(function(){
	        console.log("fail");
	      }).always(function(){
	        console.log("always");
	      });

      	$.post("/api/v1/members/search", {"q": ""})
      		.done(function(data){
	        	displayMembers(data);
	      	}).fail(function(){
	        	console.log("fail");
	      	}).always(function(){
	        	console.log("always");
	      	});

	}



});
