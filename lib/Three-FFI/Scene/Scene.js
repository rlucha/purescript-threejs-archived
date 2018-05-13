var Scene = require("three").Scene

var createScene = function() {
  return new Scene()
}

// Color has to be a Three.Color
var setSceneBackground = function(color) {
  return function(scene) {
    return function() {
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
