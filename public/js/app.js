(function(/*! Brunch !*/) {
  'use strict';

  var globals = typeof window !== 'undefined' ? window : global;
  if (typeof globals.require === 'function') return;

  var modules = {};
  var cache = {};

  var has = function(object, name) {
    return ({}).hasOwnProperty.call(object, name);
  };

  var expand = function(root, name) {
    var results = [], parts, part;
    if (/^\.\.?(\/|$)/.test(name)) {
      parts = [root, name].join('/').split('/');
    } else {
      parts = name.split('/');
    }
    for (var i = 0, length = parts.length; i < length; i++) {
      part = parts[i];
      if (part === '..') {
        results.pop();
      } else if (part !== '.' && part !== '') {
        results.push(part);
      }
    }
    return results.join('/');
  };

  var dirname = function(path) {
    return path.split('/').slice(0, -1).join('/');
  };

  var localRequire = function(path) {
    return function(name) {
      var dir = dirname(path);
      var absolute = expand(dir, name);
      return globals.require(absolute);
    };
  };

  var initModule = function(name, definition) {
    var module = {id: name, exports: {}};
    definition(module.exports, localRequire(name), module);
    var exports = cache[name] = module.exports;
    return exports;
  };

  var require = function(name) {
    var path = expand(name, '.');

    if (has(cache, path)) return cache[path];
    if (has(modules, path)) return initModule(path, modules[path]);

    var dirIndex = expand(path, './index');
    if (has(cache, dirIndex)) return cache[dirIndex];
    if (has(modules, dirIndex)) return initModule(dirIndex, modules[dirIndex]);

    throw new Error('Cannot find module "' + name + '"');
  };

  var define = function(bundle, fn) {
    if (typeof bundle === 'object') {
      for (var key in bundle) {
        if (has(bundle, key)) {
          modules[key] = bundle[key];
        }
      }
    } else {
      modules[bundle] = fn;
    }
  };

  globals.require = require;
  globals.require.define = define;
  globals.require.register = define;
  globals.require.brunch = true;
})();

window.require.register("initialize", function(exports, require, module) {
  var Treats;

  Treats = require('treats');

  window.onload = function() {
    var treats;

    treats = new Treats();
    if (treats.init()) {
      $('#play-song').click(function() {
        return treats.playSong();
      });
      return $('#stop-song').click(function() {
        return treats.stopSong();
      });
    } else {
      $('#treat-container').hide();
      return $('#browser-warning').show();
    }
  };
  
});
window.require.register("treats", function(exports, require, module) {
  var Treats;

  module.exports = Treats = (function() {
    var freqByteData, song, songAnalyser, songContext, songSource, songUrl, treatCanvas, treatContext;

    function Treats() {}

    song = null;

    songContext = null;

    songSource = null;

    songAnalyser = null;

    songUrl = 'music/polygons.mp3';

    freqByteData = null;

    treatCanvas = document.getElementById('treat');

    treatContext = treatCanvas.getContext('2d');

    Treats.prototype.init = function() {
      if (typeof AudioContext !== 'undefined') {
        songContext = new AudioContext();
      } else if (typeof webkitAudioContext !== 'undefined') {
        songContext = new webkitAudioContext();
      } else {
        return false;
      }
      window.requestAnimationFrame = window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame;
      treatContext.canvas.width = window.innerWidth;
      treatContext.canvas.height = window.innerHeight;
      this.loadSong();
      return true;
    };

    Treats.prototype.loadSong = function() {
      var _this = this;

      song = new Audio();
      song.src = songUrl;
      song.controls = false;
      song.autoplay = false;
      song.loop = false;
      $('#treat-container').append(song);
      return song.addEventListener('canplay', function(e) {
        return _this.analyseSong();
      });
    };

    Treats.prototype.analyseSong = function() {
      songSource = songContext.createMediaElementSource(song);
      songAnalyser = songContext.createAnalyser();
      songSource.connect(songAnalyser);
      return songAnalyser.connect(songContext.destination);
    };

    Treats.prototype.playSong = function() {
      song.play();
      return this.animate();
    };

    Treats.prototype.stopSong = function() {
      return song.pause();
    };

    Treats.prototype.animate = function() {
      var color0, color1, color2, height, index, _i, _ref,
        _this = this;

      treatContext.clearRect(0, 0, treatCanvas.width, treatCanvas.height);
      freqByteData = new Uint8Array(songAnalyser.frequencyBinCount);
      songAnalyser.getByteFrequencyData(freqByteData);
      color0 = '#44bb44';
      color1 = '#bb4480';
      color2 = '#8044bb';
      treatContext.beginPath();
      for (index = _i = 0, _ref = freqByteData.length; 0 <= _ref ? _i <= _ref : _i >= _ref; index = 0 <= _ref ? ++_i : --_i) {
        height = freqByteData[index];
        treatContext.arc(treatContext.canvas.width / 300 * index, treatContext.canvas.height / 2, height, 0, 2 * Math.PI, false);
      }
      treatContext.fillStyle = color0;
      treatContext.fill();
      return window.requestAnimationFrame(function() {
        return _this.animate();
      });
    };

    return Treats;

  })();
  
});
