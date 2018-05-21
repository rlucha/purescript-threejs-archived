// TODO change all names to points

var Points = require("three").Points

exports.create = function(geometry) {
  return function(material) {
    return function() {
      return new Points(geometry, material);
    }
  }
}
