module.exports = class Treat
  constructor: (@fillColor) ->
    @canvas =  document.getElementById 'treat'
    @context = @canvas.getContext '2d'
    @frequencyByteData = new Uint8Array

  init: ->
    # Cross browser setup for AnimationFrame
    window.requestAnimationFrame =
      window.requestAnimationFrame or
      window.webkitRequestAnimationFrame or
      window.mozRequestAnimationFrame or
      window.oRequestAnimationFrame or
      window.msRequestAnimationFrame

    # Set canvas to window's size
    @context.canvas.width = window.innerWidth
    @context.canvas.height = window.innerHeight

    @context.fillStyle = @fillColor

  animate: (beat) ->
    # Clear canvas from previous frame
    @context.clearRect 0, 0, @canvas.width, @canvas.height

    # Get song data
    if beat.analyser isnt null
      @frequencyByteData = new Uint8Array beat.analyser.frequencyBinCount
      beat.analyser.getByteFrequencyData @frequencyByteData

    @context.beginPath()
    for index in [0..@frequencyByteData.length]
      height = @frequencyByteData[index]
      @context.arc @context.canvas.width / 300 * index,
                   @context.canvas.height / 2,
                   height, 0 , 2 * Math.PI, false
    @context.fill()

    window.requestAnimationFrame => @animate(beat)
