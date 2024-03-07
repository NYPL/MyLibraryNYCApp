function activateSchool(schoolId, activate) {
    if (activate == true){
      $('#activate-school-' + schoolId + '-container').hide();
      $('#inactivate-school-' + schoolId + '-container').show();
    } else {
      $('#inactivate-school-' + schoolId + '-container').hide();
      $('#activate-school-' + schoolId + '-container').show();
    }
  };
  
  function makeAvailableTeacherSet(teacherSetId, make_available) {
    if (make_available == true){
      $('#make-available-teacher-set-' + teacherSetId + '-container').hide();
      $('#make-unavailable-teacher-set-' + teacherSetId + '-container').show();
    } else {
      $('#make-unavailable-teacher-set-' + teacherSetId + '-container').hide();
      $('#make-available-teacher-set-' + teacherSetId + '-container').show();
    }
  };
  
  $( document ).ready(function() {
  
    if($('#hold_change_comment').length) {
      
      // Prebaked messages TODO: make configurable via admin
      var prebaked = {
        closed: [
          {name: 'Closed', content: "Hello from MyLibraryNYC Fulfillment,\n\nWe received your Teacher Set order and it is " +
            "being processed by our staff now. Please expect to receive the shipment in 1-2 weeks. If you have any questions" +
            " about your order please email: delivery@mylibrarynyc.org."}
        ],
        'pending_-_unavailable': [  
          {name: 'Pending: Set is Unavailable', content: "Hello from MyLibraryNYC Fulfillment,\n\nWe received " +
            "your Teacher Set order but we are unable to fulfill your request at this time. All copies of this " +
            "set are currently checked out and being used by other Educators.\n\nIf you would like help with " +
            "selecting another Teacher Set or would like to be placed in Queue to wait for this Teacher Set, please email: help@mylibrarynyc.org ."}
        ],
        'pending_-_trouble_shooting': [
          {name: 'Pending: Duplicate Set Order', content: "Hello from MyLibraryNYC Fulfillment,\n\nWe received " +
            "your Teacher Set order but you have placed duplicate requests of the same set. We will fulfill " +
            "one set IF AVAILABLE but cannot fill the duplicate order requests at this time.\n\nIf you would " +
            "like help with selecting another Teacher Set or would like to be placed in Queue to wait for " +
            "the duplicate Teacher Sets,  please email: help@mylibrarynyc.org."},
          {name: 'Problem: Other', content: "Hello from MyLibraryNYC Fulfillment,\n\nWe received your Teacher Set " +
            "order, but unfortunately are not able to fulfill the order. Please contact delivery@mylibrarynyc.org for more details."}
        ],
        cancelled: [
          {name: 'Cancelled', content: "Cancelled"}
        ]
      }
  
      // Textarea to modify:
      var t_area = $('#hold_change_comment');
  
      // When status changed, show/hide appropriate prepared-message links
      $('#hold_change_status_input input[type=radio]').change(function() {
        if($(this).is(':checked')) {
          t_area.siblings('a').hide();
          t_area.siblings('a.status-' + $(this).val().split(' ').join('_').toLowerCase()).show();
        }
      });
     
      // This removes previoiusly-inserted prepared statements (i.e. admin changed mind about which to use)
      var clearExistingPreparedMessages = function() {
        $.each(prebaked, function (_status, messages) {
          $.each(messages, function(i, message) {
            var current = t_area.val();
            t_area.val(current.replace(message.content, ''));
          });
        });
      };
  
      // This sets the given prepared message into the tarea, replacing previously added
      var setPreparedMessage = function(str) {
        var current = t_area.val();
  
        if(current.indexOf($(this).data('message')) < 0) {
          t_area.val(current + (current.replace(/\s*/,'').length > 0? "\n" : '') + str);
        }
      };
  
      // Add prepared-notes links to top of textarea
      t_area.before('Prepared notes: ');
      $.each(prebaked, function (_status, messages) {
        $.each(messages, function(i, message) {
          var a = $('<a href="javascript:void(0);" title="Add prepared statement">' + message.name + '</a>').addClass('status-' + _status);
          a.data('message', message.content);
          a.click(function() {
            clearExistingPreparedMessages();
            setPreparedMessage($(this).data('message'));
          });
          $('#hold_change_comment').before(a);
        });
      });
    }
  
    var image_uris = {};
    var title_uris = {};
    $('.has_many.books fieldset').each(function(i) {
      var el = $(this);
      var radios = $(el.find('input[id*=catalog_choice]'));
      el = $(radios[0]);
      if(!el.data('titles')) return;
  
      $.each(el.data('titles'), function(i, t) {
        if(t['isbns'])
          image_uris[t['id']] = 'http://contentcafe2.btol.com/ContentCafe/Jacket.aspx?&userID=NYPL49807&password=CC68707&content=M&Return=1&Type=S&Value=' + t['isbns'][0];
        title_uris[t['id']] = t['details_url']
      });
      // console.log("set image uri: ", image_uris, title_uris);
      
      var last = $(radios[radios.length - 1]);
      last.change(function(e) {
        if($(this).is(":checked")) {
          $(this).parents('fieldset').addClass('re-search');
        } else
          $(this).parents('fieldset').addClass('re-search');
      });
    });
  
    $('input[id*=catalog_choice]').each(function(i) {
      var el = $(this);
      var img = $('<img alt="No image"/>');
      var link = $('<a/>').attr('href', title_uris[el.val()]).attr('target', '_blank');
      var img_holder = $('<div class="img-holder"/>').append( title_uris[el.val()] ? link.append(img) : '');
      el.before(img_holder);
      img.attr('src', image_uris[el.val()]);
    });
  });
  