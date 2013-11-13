Beat = require 'beat'
Treat = require 'treat'

$ ->
  beat = new Beat('beats/polygons.mp3')
  treat = new Treat('#44bb44', '#bb44bb', beat)

  # If the beat initializes, we have browser support
  if beat.init()
    # Loading the beat into the DOM
    beat.load()

    # Initializing the animation
    treat.init()

    # Enabling song controls
    $('#play-song').click -> beat.play()
    $('#stop-song').click -> beat.stop()

  # If the beat fails to initialize, we don't have browser support
  else
    $('#treat-container').hide()
    $('#browser-warning').show()

  $('canvas').hide();

  $('#find-song').click ->
    $.getJSON 'http://api.soundcloud.com/tracks.json?client_id=f7b1cef243a83a07a61a8a84586707f2&q=ghosts%20N%27%20Stuff&order=hotness', (data) ->
      $('#treat-container').append '<ul></ul>'
      $.each data, (key, value) ->
        $('#treat-container ul').append '<li><a href="' + value.permalink_url + '">' + value.permalink + '<img src="' + value.artwork_url + '"></a></li>'
        console.log value
