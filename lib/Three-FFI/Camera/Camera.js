var PerspectiveCamera = require("three").PerspectiveCamera

var create = function(fov) {
  return function (aspect) {
    return function (near) {
      return function (far) {
        return function() {
          var camera = new PerspectiveCamera(fov, aspect, near, far)
          camera.position.set(50, 50, 50)
          camera.lookAt(0, 0, 0) 
          return camera
        }
      }
    }
  }
}

var setAspect = function(aspect) {
  return function(camera) {
    return function() {
      camera.aspect = aspect
    }
  }
}

var setPosition = function(x) {
  return function(y) {
    return function(z) {
      return function(camera) {
        return function() {
          camera.position.set(x, y, z)
        }
      }
    }
  }
}

var debug = function(camera) {
  return function() {
    window.camera = camera
  }
}

var updateProjectionMatrix = function(camera) {
  return function() {
    camera.updateProjectionMatrix()
  }
}


module.exports = {
  create: create,
  debug: debug,
  setPosition: setPosition,
  setAspect: setAspect,
  updateProjectionMatrix: updateProjectionMatrix
}
