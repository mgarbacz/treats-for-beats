module.exports = class Treats
  # Song variables
  song = null
  songContext = null
  songSource = null
  songAnalyser = null
  songUrl = 'music/polygons.mp3'
  freqByteData = null

  # Canvas variables
  treatCanvas =  document.getElementById 'treat'
  treatContext = treatCanvas.getContext '2d'

  init: ->
    # Cross browser setup for AudioContext
    if typeof AudioContext isnt 'undefined'
      songContext = new AudioContext()
    else if typeof webkitAudioContext isnt 'undefined'
      songContext = new webkitAudioContext()
    else
      return false

    # Cross browser setup for AnimationFrame
    window.requestAnimationFrame =
      window.requestAnimationFrame or
      window.webkitRequestAnimationFrame or
      window.mozRequestAnimationFrame or
      window.oRequestAnimationFrame or
      window.msRequestAnimationFrame

    # Set canvas to window's size
    treatContext.canvas.width = window.innerWidth
    treatContext.canvas.height = window.innerHeight

    # Get animation and song loading going
    @loadSong()
    return true

  loadSong: ->
    song = new Audio()
    song.src = songUrl
    song.controls = false
    song.autoplay = false
    song.loop = false

    $('#treat-container').append song

    # Weird trickery needed to load song!
    song.addEventListener 'canplay', (e) =>
      @analyseSong()

  analyseSong: ->
    songSource = songContext.createMediaElementSource song
    songAnalyser = songContext.createAnalyser()

    songSource.connect songAnalyser
    songAnalyser.connect songContext.destination

  playSong: ->
    song.play()
    @animate()

  stopSong: ->
    song.pause()

  animate: ->
    # Clear canvas from previous frame
    treatContext.clearRect 0, 0, treatCanvas.width, treatCanvas.height

    # Get song data
    freqByteData = new Uint8Array songAnalyser.frequencyBinCount
    songAnalyser.getByteFrequencyData freqByteData

    # Colors for treat
    color0 = '#44bb44'
    color1 = '#bb4480'
    color2 = '#8044bb'

    treatContext.beginPath()
    for index in [0..freqByteData.length]
      height = freqByteData[index]
      treatContext.arc treatContext.canvas.width / 300 * index,
                       treatContext.canvas.height / 2,
                       height, 0 , 2 * Math.PI, false
    treatContext.fillStyle = color0
    treatContext.fill()

    window.requestAnimationFrame => @animate()

