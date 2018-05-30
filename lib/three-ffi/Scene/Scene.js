var Scene = require("three").Scene
var Color = require("three").Color
var Fog = require("three").Fog

var create = function() {
  return new Scene()
}

// Color has to be a Three.Color
var setBackground = function(color) {
  return function(scene) {
    return function() {
      // scene.fog = new Fog(new Color( 0x000000), 1800, 3000)
      scene.background = color
      return scene
    }
  }
}

var add = function(scene) {
  return function(object) {
    return function() {
      scene.add(object)
      return scene
    }
  }
}

var debug = function(scene) {
  return function() {
    window.scene = scene
  }
}

module.exports = {
  create: create,
  setBackground: setBackground,
  add: add,
  debug: debug
}
