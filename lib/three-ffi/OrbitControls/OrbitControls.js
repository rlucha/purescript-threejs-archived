var ffi = require("ffi-utils")
var OrbitControls = require('three-orbit-controls')(require("three"))

exports.create = function(camera) {
  return function() {
    return new OrbitControls(camera)
  }
}

exports.toggle = function(status) {
  return function(controls) {
    return function() {
      controls.enabled = status
      // controls.autoRotate = true //remove
      controls.enableZoom = true //remove
    }
  }
}

exports.setAutoRotate = ffi.curry2(
  function(status, controls) {
    controls.autoRotate = status
  }
)

// Had to force this to take a number that doesn't use
exports.update = function(controls) {
  return function() {
    controls.update()
  }
}
