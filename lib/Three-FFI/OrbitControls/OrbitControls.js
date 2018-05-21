var OrbitControls = require('three-orbit-controls')(require("three"))

var createOrbitControls = function(camera) {
  return function() {
    return new OrbitControls(camera)
  }
}

var toggleControls = function(status) {
  return function(controls) {
    return function() {
      controls.enabled = status
      controls.autoRotate = true //remove
      controls.enableZoom = true //remove
    }
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
  toggleControls: toggleControls,
  updateControls: updateControls
}

// controls.update!!!

// controls.autoRotate = true;
