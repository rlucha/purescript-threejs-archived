// TODO: pass configuration 
var MeshBasicMaterial = require("three").MeshBasicMaterial

exports.create = function(color) {
  return function() {
    return new MeshBasicMaterial({color: color});
  }
}
