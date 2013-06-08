module.exports = class Beat
  constructor: (@beatUrl) ->
    @beat = null
    @context = null
    @source = null
    @analyser = null

  init: ->
    #Cross browser setup for AudioContext
    if typeof AudioContext isnt 'undefined'
      @context = new AudioContext()
    else if typeof webkitAudioContext isnt 'undefined'
      @context = new webkitAudioContext()
    else
      # AudioContext not supported
      return false

    # AudioContext supported
    return true

  load: ->
    @beat = new Audio()
    @beat.src = @beatUrl
    @beat.controls = false
    @beat.autoplay = false
    @beat.loop = false

    $('#treat-container').append @beat

    # Wait for canplay event to run analyser
    @beat.addEventListener 'canplay', (e) =>
      @analyse()

  analyse: ->
    @source = @context.createMediaElementSource @beat
    @analyser = @context.createAnalyser()

    @source.connect @analyser
    @analyser.connect @context.destination

  play: ->
    @beat.play()

  stop: ->
    @beat.pause()

