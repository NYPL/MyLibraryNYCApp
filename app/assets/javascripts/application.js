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
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require ./vendor/jquery.ui.touch-punch.min
//= require ./vendor/jquery.swipeshow.min
//= require helpers
//= require rails.validations


/**
* Makes the success/error alert at the top of the page disappear, 
* when the user clicks anywhere on the body of the page.
* 
* WARNING:  application.js file functions will not work on angular-coded pages.
* For those pages, look for similar functionality in the hideErrorDiv() function.
*/
$(document).ready(function() {
  $("#main").click(function(){
    $("#error_messages_id").hide();
  });
});


$(document).ready(function() {
  $("#search_participating_school").on("keyup", function() {
    var value = $(this).val().toLowerCase();
    var count = 0;
    $("#participating_schools_id *").filter(function() {
      if ($(this).text().toLowerCase().indexOf(value) > -1) count++;
      $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
    });

    if(count == 0){
      $("#schools_not_found").html("Schools are not found")
    }
    else {
      $("#schools_not_found").html("")
    }
  });
});
