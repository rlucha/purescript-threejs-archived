var Scene = require("three").Scene
var Color = require("three").Color
var Fog = require("three").Fog

var createScene = function() {
  return new Scene()
}

// Color has to be a Three.Color
var setSceneBackground = function(color) {
  return function(scene) {
    return function() {
      scene.fog = new Fog(new Color( 0x000000), 1800, 3000)
      scene.background = color
      return scene
    }
  }
}

var addToScene = function(object) {
  return function(scene) {
    return function() {
      scene.add(object)
      return scene
    }
  }
}

var debugScene = function(scene) {
  return function() {
    window.scene = scene
  }
}

module.exports = {
  createScene: createScene,
  setSceneBackground: setSceneBackground,
  addToScene: addToScene,
  debugScene: debugScene
}
