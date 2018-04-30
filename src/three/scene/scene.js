var Scene = require("three").Scene

var createScene = function() {
  return new Scene()
}

// Color has to be a Three.Color
var setSceneBackground = function(scene) {
  return function(color) {
    return function() {
      scene.background = color
      return scene
    }
  }
}

module.exports = {
  createScene: createScene,
  setSceneBackground: setSceneBackground
}
