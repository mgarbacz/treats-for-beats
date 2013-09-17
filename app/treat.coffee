module.exports = class Treat
  constructor: (@fillColor1, @fillColor2, @sourceBeat) ->
    @canvas1 =  document.getElementById 'treat1'
    @context1 = @canvas1.getContext '2d'
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
    canvasWidth = window.innerWidth / Math.cos(canvasRotationAngle)
    canvasHeight = window.innerHeight / 2

    @context1.canvas.width = canvasWidth
    @context1.canvas.height = canvasHeight
    @context2.canvas.width = canvasWidth
    @context2.canvas.height = canvasHeight

    @context1.fillStyle = @fillColor1
    @context2.fillStyle = @fillColor2

    # Start animating when song begins playing
    @sourceBeat.audio.addEventListener 'playing', (e) =>
      console.log('playing')
      this.animate()

    @sourceBeat.audio.addEventListener 'pause', (e) =>
      console.log('paused')

  animate: ->
    # Clear canvas from previous frame
    @context1.clearRect 0, 0, @canvas1.width, @canvas1.height
    @context2.clearRect 0, 0, @canvas2.width, @canvas2.height

    # Get song data from source beat if beat is playing
    if @sourceBeat.analyser isnt null
      @frequencyByteData =
        new Uint8Array @sourceBeat.analyser.frequencyBinCount
      @sourceBeat.analyser.getByteFrequencyData @frequencyByteData

    # Drawing first 32 elements of song data as `bubbles` of radius 20 that bob
    # up and down by the number given as frequencyByteData for said element
    @context1.beginPath()
    @context2.beginPath()
    for index in [0..15]
      bubbleBob1 = @frequencyByteData[index]
      bubbleBob2 = @frequencyByteData[index + 16]
      bubbleRadius = 35
      bubbleX = @context1.canvas.width / 15 * index
      bubbleY = @context1.canvas.height + bubbleRadius

      @context1.arc bubbleX, bubbleY - bubbleBob1, bubbleRadius,
                    0, 2 * Math.PI, false
      @context2.arc bubbleX, bubbleY - bubbleBob2, bubbleRadius,
                    0, 2 * Math.PI, false

    @context1.fill()
    @context2.fill()

    # Do next frame, unless song is paused
    window.requestAnimationFrame => @animate() if !@sourceBeat.audio.paused
