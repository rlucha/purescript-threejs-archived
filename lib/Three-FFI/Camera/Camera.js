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
          // return new PerspectiveCamera(fov, aspect, near, far)
        }
      }
    }
  }
}

module.exports = {
  createPerspectiveCamera: createPerspectiveCamera
}