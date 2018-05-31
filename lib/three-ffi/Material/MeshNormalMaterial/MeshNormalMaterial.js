// TODO: pass configuration 
var ffi = require("ffi-utils")
var MeshNormalMaterial = require("three").MeshNormalMaterial

exports.create = ffi.curry2(
  function(color, lights) {
    return new MeshNormalMaterial({color: color, lights: lights});
  }
)
