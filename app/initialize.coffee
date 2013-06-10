Beat = require 'beat'
Treat = require 'treat'

window.onload = ->
  beat = new Beat('beats/polygons.mp3')
  treat = new Treat('#44bb44', beat)

  if beat.init()
    beat.load()

    treat.init()
    treat.animate()

    $('#play-song').click ->
      beat.play()
    $('#stop-song').click ->
      beat.stop()
  else
    $('#treat-container').hide()
    $('#browser-warning').show()
