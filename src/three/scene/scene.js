var Scene = require("three").Scene

var createScene = function() {
  return new Scene()
}

// Color has to be a Three.Color
var setSceneBackground = function(color) {
  return function(scene) {
    scene.background = color
  }
}

module.exports = {
  createScene: createScene,
  setSceneBackground: setSceneBackground
}
