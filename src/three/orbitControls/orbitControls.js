var OrbitControls = require('three-orbit-controls')(require("three"))

var createOrbitControls = function(camera) {
  return function() {
    return new OrbitControls(camera)
  }
}

var enableControls = function(controls) {
  return function() {
    controls.enabled = true
    return controls
  }
}

var updateControls = function(controls) {
  return function() {
    controls.update()
    return controls
  }
}


module.exports = {
  createOrbitControls: createOrbitControls,
  enableControls: enableControls,
  updateControls: updateControls
}

// controls.update!!!

// controls.autoRotate = true;