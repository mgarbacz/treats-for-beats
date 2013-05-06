Treats = require 'treats'

window.onload = ->
  treats = new Treats()
  if treats.init()
    $('#play-song').click -> treats.playSong()
    $('#stop-song').click -> treats.stopSong()
  else
    $('#treat-container').hide()
    $('#browser-warning').show()

