// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//= require info-site/jquery_bc
//= require info-site/analytics
//= require info-site/menu
//= require info-site/jquery_ui_bc
//= require info-site/doe_schools
//= require info-site/cookie

$( document ).ready(function() {
  //toggle the component with class answers
  $(".questions").click(function() {
    if ($(this).next(".answers").is(':visible')) {
      $(this).next(".answers").slideUp(300);
      $(this).children(".plusminus").text('+');
    } else {
      $(this).next(".answers").slideDown(300);
      $(this).children(".plusminus").text('-');
    }
  });
});