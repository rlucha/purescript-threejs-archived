var ffi = require("ffi-utils")
var AmbientLight = require("three").AmbientLight

exports.create_ = ffi.curry2(
  function(color, intensity) {
    return new AmbientLight(color, intensity);
  }
)
