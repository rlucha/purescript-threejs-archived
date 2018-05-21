// TODO: pass configuration 
var MeshBasicMaterial = require("three").MeshBasicMaterial

exports.createMeshBasicMaterial = function(color) {
  return function() {
    return new MeshBasicMaterial({color: color});
  }
}
