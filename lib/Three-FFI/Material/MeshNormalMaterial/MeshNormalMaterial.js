// TODO: pass configuration 
var MeshNormalMaterial = require("three").MeshNormalMaterial

exports.create = function(color) {
  return function(lights) {
    return function() {
      return new MeshNormalMaterial({color: color, lights: lights});
    }
  }
}
