var OrbitControls = require('three-orbit-controls')(require("three"))

var createOrbitControls = function(camera) {
  return function() {
    return new OrbitControls(camera)
  }
}

var enableControls = function(controls) {
  return function() {
    controls.enabled = true
    // controls.autoRotate = true //remove
    controls.enableZoom = true //remove
    return controls
  }
}

// Had to force this to take a number that doesn't use
var updateControls = function(controls) {
  return function() {
    controls.update()
  }
}


module.exports = {
  createOrbitControls: createOrbitControls,
  enableControls: enableControls,
  updateControls: updateControls
}

// controls.update!!!

// controls.autoRotate = true;