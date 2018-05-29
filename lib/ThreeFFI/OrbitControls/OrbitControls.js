var OrbitControls = require('three-orbit-controls')(require("three"))

var create = function(camera) {
  return function() {
    return new OrbitControls(camera)
  }
}

var toggle = function(status) {
  return function(controls) {
    return function() {
      controls.enabled = status
      // controls.autoRotate = true //remove
      controls.enableZoom = true //remove
    }
}
}

// Had to force this to take a number that doesn't use
var update = function(controls) {
  return function() {
    controls.update()
  }
}


module.exports = {
  create: create,
  toggle: toggle,
  update: update
}

// controls.update!!!

// controls.autoRotate = true;
