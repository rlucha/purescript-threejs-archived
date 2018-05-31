// TODO: pass configuration 
var ffi = require("ffi-utils")
var MeshBasicMaterial = require("three").MeshBasicMaterial

exports.create = ffi.curry1(
  function(color) {
    return new MeshBasicMaterial({color: color});
  }
)
