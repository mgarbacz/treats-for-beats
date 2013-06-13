Beat = require 'beat'
Treat = require 'treat'

window.onload = ->
  beat = new Beat('beats/polygons.mp3')
  treat = new Treat('#44bb44', beat)

  # If the beat initializes, we have browser support
  if beat.init()
    # Loading the beat into the DOM
    beat.load()

    # Initializing and starting the animation
    treat.init()
    treat.animate()

    # Enabling song controls
    $('#play-song').click -> beat.play()
    $('#stop-song').click -> beat.stop()

  # If the beat fails to initialize, we don't have browser support
  else
    $('#treat-container').hide()
    $('#browser-warning').show()
