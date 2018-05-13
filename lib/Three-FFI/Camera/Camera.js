var PerspectiveCamera = require("three").PerspectiveCamera

var createPerspectiveCamera = function(fov) {
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

var setCameraPosition = function(x) {
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

var debugCamera = function(camera) {
  return function() {
    window.camera = camera
  }
}


module.exports = {
  createPerspectiveCamera: createPerspectiveCamera,
  debugCamera: debugCamera,
  setCameraPosition: setCameraPosition
}