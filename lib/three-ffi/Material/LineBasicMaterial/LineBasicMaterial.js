// TODO: pass configuration 
var ffi = require("ffi-utils")
var LineBasicMaterial = require("three").LineBasicMaterial

exports.create = ffi.curry1(
  function(color) {
    return new LineBasicMaterial({color: color});
  }
)
