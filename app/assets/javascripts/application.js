// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require turbolinks
//= require bootstrap
//= require jquery_readyselector
//= require bootstrap-switch.min
//= require_tree .

$(document).on('turbolinks:load', function(e){
  $(".wcc-nav").parent().removeClass('active');
  if( $(e.target.body).hasClass('accounts') ){
    $("#accounts-nav").parent().addClass('active');
  }else if( $(e.target.body).hasClass('memberships') ){
    $("#memberships-nav").parent().addClass('active');
  }else if( $(e.target.body).hasClass('wineries') ){
    $("#wineries-nav").parent().addClass('active');
  }else if( $(e.target.body).hasClass('clubs') ){
    $("#clubs-nav").parent().addClass('active');
  }else if( $(e.target.body).hasClass('users') ){
    $("#users-nav").parent().addClass('active');
  }else if( $(e.target.body).hasClass('subscriptions') ){
    $("#subscriptions-nav").parent().addClass('active');
  }
});
