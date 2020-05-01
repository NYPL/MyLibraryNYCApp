# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  loader = $('.loader')

  bookset_messages =
    message_elem: $('.bookset_messages')
    input_elem: $("#bookset_subscriber_email")
    submit_elem: $('#booksets_submit')

    set_message: (message) ->
      this.message_elem.text(message).show()
      this

    hide: ->
      this.input_elem.val ""
      setTimeout (=>
        this.message_elem.fadeOut('slow', =>
          this.message_elem.text('')
        )
        $('#booksets_submit').removeAttr('disabled')
      ), 5000


  $('#new_bookset_subscriber')
    .bind('ajax:beforeSend', (event, xhr, settings) ->
      loader.addClass('show')
      bookset_messages.submit_elem.attr('disabled','disabled')
    )

    .bind('ajax:success', (event, data, status, xhr) ->
      if status is 'success'
        message = "Your email " + data.email + " has been added. " +  
          "A confirmation email has been sent."

        bookset_messages.set_message(message)
    )

    .bind('ajax:complete', (event, xhr, status) ->
      loader.removeClass('show')
      bookset_messages.hide()
    )

    .bind 'ajax:error', (event, xhr, status, error) ->
      # email_errors = (JSON.parse(xhr.responseText)).email[0]
      bookset_messages.set_message(xhr.responseText)
