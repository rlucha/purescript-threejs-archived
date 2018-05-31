var ffi = require("ffi-utils")
var DirectionalLight = require("three").DirectionalLight

exports.create_ = ffi.curry2(
  function(color, intensity) {
    return new DirectionalLight(color, intensity);
  }
)
 