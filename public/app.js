(function() {
  // Song stuff
  var songContext,
      songSource,
      songBuffer,
      songAnalyser,
      freqByteData,
      url = 'music/polygons.mp3';

  // Canvas stuff 
  var treatCanvas = document.getElementById('treat'),
      context = treatCanvas.getContext('2d');
  context.canvas.width = window.innerWidth;
  context.canvas.height = window.innerHeight;

  function init() {
    // Cross browser setup for AudioContext
    if (typeof AudioContext !== 'undefined')
      songContext = new AudioContext();
    else if (typeof webkitAudioContext !== 'undefined')
      songContext = new webkitAudioContext();
      
    // Cross browser setup for animation frame requests
    window.requestAnimFrame = (function(callback) {
      return window.requestAnimationFrame
        || window.webkitRequestAnimationFrame
        || window.mozRequestAnimationFrame
        || window.oRequestAnimationFrame
        || window.msRequestAnimationFrame
        || function(callback) { window.setTimeout(callback, 1000 / 60); }
    })();
  }

  function loadSong() {
    var request = new XMLHttpRequest();
    request.open("GET", url, true);
    request.responseType = 'arraybuffer';

    request.onload = function() {
      var songData = request.response;
      songGraph(songData);
    };

    request.send();
  }

  function playSong() {
    songSource.noteOn(songContext.currentTime);

    freqByteData = new Uint8Array(songAnalyser.frequencyBinCount);
    animate();
  }

  function stopSong() {
    songSource.noteOff(songContext.currentTime);
  }

  function songGraph(songData) {
    songSource = songContext.createBufferSource();
    songAnalyser = songContext.createAnalyser();
    songAnalyser.fftSize = 1024;

    songBuffer = songContext.createBuffer(songData, false);
    songSource.buffer = songBuffer;
    songSource.connect(songAnalyser);
    songAnalyser.connect(songContext.destination);

    playSong(songSource);
  }

  // Called every frame
  function animate() {
    // Clear canvas
    context.clearRect(0, 0, treatCanvas.width, treatCanvas.height);

    // Get song data
    songAnalyser.smoothingTimeConstant = 0.1;
    songAnalyser.getByteFrequencyData(freqByteData);

    // Colors for treat
    var color0 = '#44bb44';
    var color1 = '#bb4480';
    var color2 = '#8044bb';

    context.beginPath();
    for (var i = 0; i < freqByteData.length; i++) {
      var height = freqByteData[i];
      context.arc(context.canvas.width / 300 * i, context.canvas.height / 2,
        height, 0, 2 * Math.PI, false);
    }
    context.fillStyle = color0;
    context.fill();

    // Request new animation frame
    requestAnimFrame(function() {
      animate();
    });
  }

  $(function() {
    init();
    $('#play-song').click(function() { loadSong(); });
    $('#stop-song').click(function() { stopSong(); });
  });
    
}());
