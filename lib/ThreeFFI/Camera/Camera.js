var PerspectiveCamera = require("three").PerspectiveCamera
var ffi = require("ffi-utils")

exports.create = ffi.curry4(
  function(fov, aspect, near, far) {
    var camera = new PerspectiveCamera(fov, aspect, near, far)
    camera.position.set(50, 50, 50)
    camera.lookAt(0, 0, 0) 
    return camera
  }
)

exports.setAspect = ffi.curry2(
  function(aspect, camera) {
    camera.aspect = aspect
  }
);

exports.setPosition = ffi.curry4(
  function(x, y, z, camera) {
    camera.position.set(x, y, z)
  }
)

exports.debug = ffi.curry1(
  function(camera) {
    window.camera = camera
  }
)

exports.updateProjectionMatrix = ffi.curry1(
  function(camera) {
    camera.updateProjectionMatrix()
  }
)
