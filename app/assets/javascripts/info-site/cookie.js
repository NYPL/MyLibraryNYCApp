
var cookie_manager = {
  cookies: [ 'doe_school_name', 'doe_school_borough', 'doe_school_url' ],

  get_cookie: function(c_name) {
    var i, x, y, ARRcookies = document.cookie.split(";");
    for (i = 0; i < ARRcookies.length; i++) {
      x = ARRcookies[i].substr(0,ARRcookies[i].indexOf("="));
      y = ARRcookies[i].substr(ARRcookies[i].indexOf("=")+1);
      x = x.replace(/^\s+|\s+$/g,"");
      if (x == c_name) {
        return unescape(y);
      }
    }
  },
  check_cookies: function(cookies) {
    var cookie_values = {};
    for (var i = 0; i < cookies.length; i++) {
      var cookie = cookies[i];
      if (!this.get_cookie(cookie)) {
        return false;
      }
    }
    return true;
  },
  get_cookie_data: function(cookies) {
    var cookie_values = {};
    for (var i = 0; i < cookies.length; i++) {
      var cookie = cookies[i];
      cookie_values[cookie] = this.get_cookie(cookie);
    }
    return cookie_values;
  },
  prepopulate_widget: function(cookie_values) {
    $('#location_name').removeAttr('disabled').val(cookie_values.doe_school_name);
    $('#city_link').val(cookie_values.doe_school_borough);
    $('#visit_website').removeClass('disable').attr('href', cookie_values.doe_school_url);

  },
  set_cookies: function() {
    document.cookie = 'doe_school_name=' + $('#location_name').val();
    document.cookie = 'doe_school_borough=' + $('#city_link').val();
    document.cookie = 'doe_school_url=' + $('#visit_website').attr('href');
  },
  run: function() {
    var cookies = this.cookies;
    if (this.check_cookies(cookies)) {
      var cookie_values = this.get_cookie_data(cookies);
      this.prepopulate_widget(cookie_values);
    }
  },  
};

$(document).ready(function() {
  if (!$.browser.msie || ($.browser.msie && parseInt($.browser.version) > 8)) {
    cookie_manager.run();
    $('#visit_website').click(function() {
      cookie_manager.set_cookies();
    });
     $('#location_name').bind('click', function() {
        if ($.browser.msie) {
          $('#city_link').trigger('click');
          $(this).focus();
        }
        else {
          $('#city_link').trigger('change');
        }
     });
   }
});

