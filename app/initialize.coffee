Beat = require 'beat'
Treat = require 'treat'

window.onload = ->
  # Get beat going
  beat = new Beat('beats/polygons.mp3')
  if beat.init()
    beat.load()
    $('#play-song').click -> beat.play()
    $('#stop-song').click -> beat.stop()
  else
    $('#treat-container').hide()
    $('#browser-warning').show()

  # Get treat going
  treat = new Treat('#44bb44')
  treat.init()
  treat.animate(beat)

