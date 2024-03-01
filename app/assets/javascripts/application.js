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
    var search_keyword = $(this).val();
    var value = $(this).val().trim().toLowerCase();
    var count = 0;
    if (value != '#') {
      $("#participating_schools_id *").filter(function() {
        if(!$(this).hasClass('alphabet_anchor')) {
          if ($(this).text().toLowerCase().indexOf(value) > -1) count++;
            $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
          }
      });
    }

    if(count == 0) {
      $("#schools_not_found").show();
      $("#schools_not_found").html(search_keyword + " did not match any schools");
      $("#participating_schools_id *").filter(function() {
        $(this).toggle($(this).text().toLowerCase().indexOf(value) == -1)
      });
    } else {
      $("#schools_not_found").hide();
      $("#schools_not_found").html("");
    }
  });
});

function hideSchoolNotFoundMessage(val=null) {
  $("#schools_not_found").hide();
  $("#participating_schools_id *").filter(function() {
    $(this).toggle($(this).text().toLowerCase().indexOf() == -1)
  });
}

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


function hideNewsLetterValidation(email) {
  if(email != "") {
    $('#nl_message').html("");
    $('#nl_message').hide();
    $('#submit').val('Subscribe');
  } else {
    $('#submit').prop('disabled', false);
    $('#submit').css("background-color", '#AF2228');
  }
}

// validate news letter email address.
function validateNewsLetterEmail(event) {
  event.preventDefault();
  email = $("#email").val();
  if(!email.length){
    $('#nl_message').html("Please enter a valid email address");
    $('#nl_message').css("color", '#c4262d');
    $('#nl_message').show();
    return false;
   } else {
    $('#nl_message').html("");
    $('#nl_message').hide();
   }
}

// function verifyNewsLetterEmailInSignUpPage(val, email, alt_email) {
//   // If alternate email is present in sign-up page take alternate-email to send news-letters other-wise DOE email.
//   news_letter_email = alt_email
//   if (news_letter_email == ""){
//     news_letter_email = email
//   }
  
//   if ($('input[id=news_letter_email]').is(':checked')) {
//     $('#news-letter-ajax-message').show();
//     $('#news-letter-ajax-message').html('Verifying email')
//     $('#news-letter-ajax-message').css("color", '#c4262d');
//     $("#sign_up_button").prop("disabled", false);
//     $("#sign_up_button").css("background-color", "grey");

//     // Ajax call to validate the news-letter email.
//     $.ajax({ type: "POST", url: "/news_letter/validate_news_letter_email_from_user_sign_up_page", contentType: "application/json; charset=utf-8",
//              data: JSON.stringify({email: news_letter_email, sign_up_page: true}), dataType: "json", success: function (result) {


//         if (result.success == "success") {
//           $('#news-letter-ajax-message').html('');
//           //$("#news_letter_email").attr("disabled", true);
//           $('input[id=news_letter_email]').attr('checked', true);
//         }
//         else if (result.error != "") {
//           $('#news-letter-ajax-message').html(result.error);
//           if (result.error == "Please enter a valid email address"){
//             $("#news_letter_email").attr("disabled", false);
//           } else {
//             $('input[id=news_letter_email]').attr('checked', false);
//             $("#news_letter_email").attr("disabled", true);
            
//           }
//         }
//         $("#sign_up_button").prop("disabled", false);
//         $("#sign_up_button").css("background-color","#af2228")
            
//     },
//     error: function (error){
//     }});
//   } 
//   else {
//     $('#news-letter-ajax-message').html('');
//     $("#sign_up_button").css("background-color","#af2228")
//   }
// }


function newsLetterCheckbox() {
  $('#news-letter-ajax-message').html('');
  $("#news_letter_email").attr("disabled", false);
  $('input[id=news_letter_email]').attr('checked', false);
}