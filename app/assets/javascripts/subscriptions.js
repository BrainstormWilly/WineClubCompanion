var subscriptions = [];
var activities = [];
var wineries = [];

function user_is_subscribed_to_delivery(subscription){
  for(var i=0; i<subscriptions.length; i++){
    if( subscriptions[i].delivery_id == subscription.delivery_id && subscriptions[i].activated ){
      return true;
    }
  }
  return false;
}

function updateSubscription(id, activated){
  s = $.grep(subscriptions, function(v,i){
    return v.id == id;
  });
  s[0].activated = activated;
}


function displaySubscriptions(){
  var s,t;
  $("#subscriptions_list").empty();
	$.each(activities, function(i,v){
		t = "<div id='" + v.id + "' class='list-group-item'><strong>" + v.name + "</strong><br/>";
    s = $.grep(subscriptions, function(vv,ii){
      return vv.activity_id == v.id;
    });

    $.each(s, function(ii,vv){
      t += "<input type='checkbox' class='subscription_delivery_switches' data-label-text='" + vv.delivery_channel + "' data-subscription-id='" + vv.id + "' ";

      if( user_is_subscribed_to_delivery(vv) ){
        t += "checked='checked'";
      }
      t += "> ";
    });
    t += "</div>";
    $("#subscriptions_list").append(t);
  });
  $(".subscription_delivery_switches").bootstrapSwitch();
  $(".subscription_delivery_switches").on('switchChange.bootstrapSwitch', function(e, state){
    setSubscription( $(e.currentTarget).data("subscription-id"), state );
  });
}

function displaySubscriptionWineries(){
  var t;
  $("#subscriptions_winery_list").empty();
  $.each(wineries, function(i,v){
    t = "<a href data-turbolinks='false' data-id='" + v.id + "' class='list-group-item subscriptions_winery_list_item";
    if( i==0 ){
      t += " disabled";
    }
    t += "' ><h5>" + v.name + "</h5>";
    t += "</a>";
    $("#subscriptions_winery_list").append(t);
  });
  $(".subscriptions_winery_list_item").on('click', function(e){
    e.preventDefault();
    $(".subscriptions_winery_list_item").removeClass("disabled");
    $(e.currentTarget).addClass("disabled");
    getActivitiesByWinery( $(e.currentTarget).data("id") );
  });
}

function getWineries(){
  $.get("/api/v1/wineries", function(){
    }).done(function(data){
      wineries = data;
      displaySubscriptionWineries();
      getSubscriptions();
    }).fail(function(){
      console.log("fail");
    }).always(function(){
      console.log("always");
    });
}

function getSubscriptions(){
  $.get("/api/v1/subscriptions", function(){
    }).done(function(data){
      subscriptions = data;
      getActivitiesByWinery(0);
    }).fail(function(){
      console.log("fail");
    }).always(function(){
      console.log("always");
    });
}

function getActivitiesByWinery(id){
  $.get("/api/v1/activities/winery/" + id, function(){
    }).done(function(data){
      activities = data;
      displaySubscriptions();
    }).fail(function(){
      console.log("fail");
    }).always(function(){
      console.log("always");
    });
}

function setSubscription(id, state){
  var s = {activated: state};
  $.ajax({
    url: "/api/v1/subscriptions/" + id,
    data: {"subscription": s},
    type: "PUT",
    success: function(result){
      updateSubscription(id, result.activated);
    },
    error: function(){
      console.log("error");
    }
  });
}


$(document).on('turbolinks:load', function(e){

	if( $(e.target.body).hasClass('subscriptions index') ){
    $.fn.bootstrapSwitch.defaults.size = 'small';
    getWineries();
  }

});
