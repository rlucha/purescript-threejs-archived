// TODO: pass configuration 
var MeshPhongMaterial = require("three").MeshPhongMaterial

exports.createMeshPhongMaterial = function(color) {
  return function(lights) {
    return function() {
      return new MeshPhongMaterial({color: '0xff0000', lights: lights});
    }
  }
}
