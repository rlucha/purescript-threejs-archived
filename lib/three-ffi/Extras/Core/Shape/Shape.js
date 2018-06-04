// TODO: pass configuration 
var ffi = require("ffi-utils")
var Shape = require("three").Shape

exports.create = ffi.curry1(
  function(v2s) {
    return new Shape(v2s);
  }
)
