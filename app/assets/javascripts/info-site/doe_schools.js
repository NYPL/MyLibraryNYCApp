var schools_path = ""; //Replace with path to schools folder, no trailing slash

function baseURL() {
    var url = location.href;
    var baseURL = url.substring(0, url.indexOf('/', 14));
    return baseURL;
}

(function( $ ){
  var schools;
  var methods = {
    init : function(options) {
      var defaults = {
        change_trigger: $('#city_link'),
        auto_complete_trigger: $('#location_name')
      };
      o =  $.extend(defaults, options);
      methods.get_library_value(o);
      $('#city_link').attr('value', '');
    },
    get_library_value: function (o) {
      var library_value, library, library_url;
      o.change_trigger.on($.browser.msie ? 'click' : 'change', function() {
        if ($(this).attr('value').length > 0) {
          library_value = $(this).attr('value');
          switch (library_value) {
            case 'nypl':
              library = 'The New York Public Library';
              library_url = 'https://browse.nypl.org/';
              methods.set_library_link(library, library_url);
              break;
            case 'bpl':
              library = 'Brooklyn Public Library';
              library_url = 'https://borrow.bklynlibrary.org';
              methods.set_library_link(library, library_url);
             break;
            case 'qpl':
              library = 'Queens Public Library';
              library_url = 'https://www.queenslibrary.org/books';
              methods.set_library_link(library, library_url);
             break;
            default:
              methods.set_library_link();
              break;
          }
        } else {
          methods.set_library_link();
        }
      });
    },
    set_library_link: function (library, library_url) {
      if (library) {
        $('#visit_website').show();
        $('#visit_website').text(library + ' Catalog');
        $('#visit_website').attr('href', library_url);
      } else {
        $('#visit_website').hide();
      }
    },
    set_school_change: function(o){
      o.auto_complete_trigger.autocomplete( "destroy" );
      o.change_trigger.on($.browser.msie ? 'click' : 'change', function() {
        if($(this).attr('value').length > 0) {
          schools_link = schools_path + $(this).attr('value');
          methods.get_school_file(o, schools_link);
        }
      });
    },
    get_school_file: function(o, schools_link) {
      $.ajax({
          url: schools_link,
          dataType: "json",
          success: function( data ) {
            schools = methods.map_data(data)
            o.auto_complete_trigger.removeAttr('disabled').val("");
            o.auto_complete_trigger.autocomplete({
              source: schools,
              change: function( event, ui ) {
              },
              minLength: 2,
              select: function(event, ui) {
                methods.create_link(ui.item.subdomain);
              }
            });

          }
      });
    },
    map_data: function (data) {
      schools =  $.map( data, function( item ) {
            if (  item.campus.length > 1 ) {
              return {
                id: item.name + " " + item.campus,
                label: item.name + " - " + item.campus,
                value: item.name,
                subdomain: item.subdomain
              };
            } else {
              return {
                id: item.name, //+ " " + item.location,
                label: item.name, //+ " @ " + item.location,
                value: item.name,
                subdomain: item.subdomain
              };
            }
            });
       return schools;
    },
    create_link: function(subdomain) {
      $('#visit_website').attr('href', 'http://' + subdomain.toLowerCase() + '.bibliocommons.com/user/login').removeClass('disable');
    }
  };

  $.city_autocomplete = function( method ) {
    if ( methods[method] ) {
      return methods[ method ].apply( this, Array.prototype.slice.call( arguments, 1 ));
    } else if ( typeof method === 'object' || ! method ) {
      return methods.init.apply( this, arguments );
    }
  }

})( jQuery );


$(window).load(function() {
      $.city_autocomplete({});
});
