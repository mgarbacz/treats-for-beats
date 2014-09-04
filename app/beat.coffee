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
    # Creating an audio element for the beat
    @audio = new Audio()
    @audio.src = @url
    @audio.controls = false
    @audio.autoplay = false
    @audio.loop = false

    # Need to stick the audio element on the page
    $('#treat-container').append @audio

    # Wait for canplay event to run analyser
    @audio.addEventListener 'canplay', (e) =>
      @analyse()

  analyse: ->
    # The analyser will allow us to have data about the beat
    @source = @context.createMediaElementSource @audio
    @analyser = @context.createAnalyser()

    # Set size of Fast Fourier Transform used to determine frequency domain
    @analyser.fftSize = 512
    # Set average constant with last frame
    @analyser.smoothingTimeConstant = 0.9

    @source.connect @analyser
    @analyser.connect @context.destination

  play: ->
    @audio.play()

  stop: ->
    @audio.pause()
