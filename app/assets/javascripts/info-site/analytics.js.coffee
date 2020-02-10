# Google Analytics Event Trackers
$(document).ready ->
	# Main Navigation Links
	$('ul.nav a').click (ev) ->
		menu =
			href:  $(this).attr('href')
			title: $(ev.target).text()
		if ( menu.href )
			_gaq.push(['_trackEvent', 'Main Navigation', 'Link Clicks', menu.title])

	# Footer Links
	$('.footer a').click ->
		links =
			href:  $(this).attr('href')
			title: $('img', this).attr('alt')
		if ( links.href && links.title )
			_gaq.push(['_trackEvent', 'Footer', 'Link Clicks', links.title])

	# Homepage - Request Individual Items
	$('#visit_website').click ->
		city = if $('#city_link').val() then $('#city_link').children('option:selected').text()
		if ( city )
			label = city + ' - ' + $(this).text()
			_gaq.push(['_trackEvent', 'Catalog Finder', 'Link Clicks', label])

	# Homepage Features Links
	$('.feature-link').click (ev) ->
		feature =
			name: $(ev.target).text()
			href: $(this).attr('href')
		if ( feature.href )
			_gaq.push(['_trackEvent', 'Homepage Features', 'Link Clicks', feature.name])
