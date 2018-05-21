var BoxGeometry = require("three").BoxGeometry

exports.createBoxGeometry = function(width) {
  return function(height) {
    return function(depth) {
      return function() {
        return new BoxGeometry(width, height, depth);
      }
    }
  }
}
