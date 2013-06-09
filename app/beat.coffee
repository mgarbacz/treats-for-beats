module.exports = class Beat
  constructor: (@url) ->
    @audio = null
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
    @audio = new Audio()
    @audio.src = @url
    @audio.controls = false
    @audio.autoplay = false
    @audio.loop = false

    $('#treat-container').append @audio

    # Wait for canplay event to run analyser
    @audio.addEventListener 'canplay', (e) =>
      @analyse()

  analyse: ->
    @source = @context.createMediaElementSource @audio
    @analyser = @context.createAnalyser()

    @source.connect @analyser
    @analyser.connect @context.destination

  play: ->
    @audio.play()

  stop: ->
    @audio.pause()
