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

    bubbleRadius = totalData / 100
    bubbleX = @context.canvas.width / 2
    bubbleY = @context.canvas.height / 2

    @context.beginPath()
    @context.arc bubbleX, bubbleY, bubbleRadius, 0, 2 * Math.PI, false
    @context.fill()

    bubblesSpeed = Math.floor(bubbleRadius)
    bubblesAmount = Math.floor(bubbleRadius)
    @spawnBubbles bubblesSpeed, bubblesAmount
    @drawBubbles()

    # Do next frame, unless song is paused
    window.requestAnimationFrame => @animate() if !@sourceBeat.audio.paused

  spawnBubbles: (amount, speed) ->
    if speed is 0
      return
    # spawn amount of bubbles specified at about speed specified
    for number in [0..amount]
      @spawnBubble speed

  spawnBubble: (speed) ->
    newBubble =
      x: @context.canvas.width / 2,
      y: @context.canvas.height / 2,
      radius: Math.random() * 20,
      speed: speed

    @bubbles.push newBubble

  drawBubbles: ->
    for bubble, index in @bubbles
      if bubble and bubble.remove
        @bubbles.splice index, 1
      if bubble
        @drawBubble bubble

  drawBubble: (bubble) ->
    @moveBubble bubble
    @context.beginPath()
    @context.arc bubble.x, bubble.y, bubble.radius, 0, 2 * Math.PI, false
    @context.fill()

  moveBubble: (bubble) ->
    randomatorX = if Math.random() > 0.5 then 1 else -1
    randomatorY = if Math.random() > 0.5 then 1 else -1
    bubble.x += randomatorX * bubble.speed
    bubble.y += randomatorY * bubble.speed

    if bubble.x > @canvas.width or bubble.y > @canvas.height
      bubble.remove = true
