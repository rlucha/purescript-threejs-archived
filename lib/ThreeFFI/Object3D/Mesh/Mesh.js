var Mesh = require("three").Mesh

exports.create_ = function(geometry) {
  return function(material) {
    return function() {
      return new Mesh(geometry, material);
    }
  }
}
