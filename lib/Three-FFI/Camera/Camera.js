var PerspectiveCamera = require("three").PerspectiveCamera

var create = function(fov) {
  return function (aspect) {
    return function (near) {
      return function (far) {
        return function() {
          var camera = new PerspectiveCamera(fov, aspect, near, far)
          // camera.aspect = 2;
          camera.position.set(50, 50, 50)
          camera.lookAt(0, 0, 0) 
          return camera
        }
      }
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


module.exports = {
  create: create,
  debug: debug,
  setPosition: setPosition
}
