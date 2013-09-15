module.exports = class Treat
  constructor: (@fillColor, @fillColor2, @sourceBeat) ->
    @canvas =  document.getElementById 'treat'
    @context = @canvas.getContext '2d'
    @canvas2 =  document.getElementById 'treat2'
    @context2 = @canvas2.getContext '2d'
    # This array stores info about our song
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
    canvasRotationAngle = (1/6) * Math.PI
    @context.canvas.width = window.innerWidth / Math.cos(canvasRotationAngle)
    @context.canvas.height = window.innerHeight / 2
    @context2.canvas.width = window.innerWidth / Math.cos(canvasRotationAngle)
    @context2.canvas.height = window.innerHeight / 2

    @context.fillStyle = @fillColor
    @context2.fillStyle = @fillColor2

  animate: ->
    # Clear canvas from previous frame
    @context.clearRect 0, 0, @canvas.width, @canvas.height
    @context2.clearRect 0, 0, @canvas2.width, @canvas2.height

    # Get song data from source beat if beat is playing
    if @sourceBeat.analyser isnt null
      @frequencyByteData =
        new Uint8Array @sourceBeat.analyser.frequencyBinCount
      @sourceBeat.analyser.getByteFrequencyData @frequencyByteData

    @context.beginPath()
    @context2.beginPath()
    # Drawing each element of song data as a circle of radius defined
    # by the number given as frequencyByteData for said element
    for index in [0..@frequencyByteData.length]
      radius = 1 + @frequencyByteData[index]
      radius2 = 1 + @frequencyByteData[index + 15]
      @context.arc @context.canvas.width / 15 * index,
                   @context.canvas.height - radius,
                   20, 0 , 2 * Math.PI, false
      @context2.arc @context2.canvas.width / 15 * index,
                    @context2.canvas.height - radius2,
                    20, 0 , 2 * Math.PI, false
    @context.fill()
    @context2.fill()

    window.requestAnimationFrame => @animate()
