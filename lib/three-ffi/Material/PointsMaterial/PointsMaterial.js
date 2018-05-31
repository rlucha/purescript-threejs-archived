// TODO: pass configuration 
var ffi = require("ffi-utils")
var PointsMaterial = require("three").PointsMaterial

exports.create = ffi.curry1(
  function(/*cfg*/) {
    return new PointsMaterial({ size: 1, sizeAttenuation: false, lights: false, fog: true } );    
  }
)
