module.exports = class Treat
  constructor: (@fillColor1, @fillColor2, @sourceBeat) ->
    @canvas =  document.getElementById 'treat'
    @context = @canvas.getContext '2d'
    @bubbles = []
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

    # Set canvas to window's size minus size of controls
    canvasWidth = window.innerWidth
    canvasHeight = window.innerHeight - 42

    @context.canvas.width = canvasWidth
    @context.canvas.height = canvasHeight

    @context.fillStyle = @fillColor1

    # Start animating when song begins playing
    @sourceBeat.audio.addEventListener 'playing', (e) =>
      console.log('playing')
      this.animate()

    @sourceBeat.audio.addEventListener 'pause', (e) =>
      console.log('paused')

  animate: ->
    # Clear canvas from previous frame
    @context.clearRect 0, 0, @canvas.width, @canvas.height

    # Get song data from source beat if beat is playing
    if @sourceBeat.analyser isnt null
      @frequencyByteData =
        new Uint8Array @sourceBeat.analyser.frequencyBinCount
      @sourceBeat.analyser.getByteFrequencyData @frequencyByteData

    totalData = 0
    for byteData in @frequencyByteData
      totalData += byteData

    pulserRadius = totalData / 100
    pulserX = @context.canvas.width / 2
    pulserY = @context.canvas.height / 2

    @context.beginPath()
    @context.arc pulserX, pulserY, pulserRadius, 0, 2 * Math.PI, false
    @context.fill()

    bubbleSpeed = Math.floor(totalData / 1000)
    if bubbleSpeed isnt 0
      @spawnBubble()
      @drawBubbles bubbleSpeed

    # Do next frame, unless song is paused
    window.requestAnimationFrame => @animate() if !@sourceBeat.audio.paused

  spawnBubble: ->
    bubble =
      x: Math.random() * @canvas.width,
      y: Math.random() * @canvas.height,
      radius: Math.random() * 20,
      direction: {}

    [bubble.direction.x, bubble.direction.y] = @chooseDirection(bubble);

    @bubbles.push bubble

  drawBubbles: (speed) ->
    for bubble, index in @bubbles
      if bubble and bubble.remove
        @bubbles.splice index, 1
      if bubble
        @drawBubble bubble, speed

  drawBubble: (bubble, speed) ->
    @moveBubble bubble, speed
    @context.beginPath()
    @context.arc bubble.x, bubble.y, bubble.radius, 0, 2 * Math.PI, false
    @context.fill()

  moveBubble: (bubble, speed) ->
    bubble.x += bubble.direction.x * speed
    bubble.y += bubble.direction.y * speed
    bubble.radius += 0.1;

    if bubble.x > @canvas.width or bubble.y > @canvas.height
      bubble.remove = true

  chooseDirection: (bubble) ->
    x = if bubble.x < @canvas.width / 2 then -1 else 1
    y = if bubble.y < @canvas.height / 2 then -1 else 1

    return [x, y]
