var PerspectiveCamera = require("three").PerspectiveCamera

var createPerspectiveCamera = function(fov) {
  return function (aspect) {
    return function (near) {
      return function (far) {
        return function() {
          return new PerspectiveCamera(fov, aspect, near, far)
        }
      }
    }
  }
}


module.exports = {
  createPerspectiveCamera: createPerspectiveCamera
}