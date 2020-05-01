# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# Main Navigation
$(document).ready ->
	$('.top-level').click (ev) ->
		ev.preventDefault()
		if $(this).next().hasClass('dropdown--active')
			$(this).next().removeClass 'dropdown--active'
			$(this).next().fadeOut()
		else
			$('.dropdown-menu').removeClass 'dropdown--active'
			$('.dropdown-menu').fadeOut()
			$(this).next().addClass 'dropdown--active'
			$(this).next().fadeIn()