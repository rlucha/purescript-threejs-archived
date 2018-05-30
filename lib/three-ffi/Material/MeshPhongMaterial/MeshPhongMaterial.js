// TODO: pass configuration 
var ffi = require("ffi-utils")
var MeshPhongMaterial = require("three").MeshPhongMaterial

exports.create = ffi.curry2(
  function(color, lights) {
    return new MeshPhongMaterial({color: color, lights: lights});
  }
)
