var ffi = require("ffi-utils")
var HemisphereLight = require("three").HemisphereLight

exports.create_ = ffi.curry3(
  function(skyColor, groundColor, intensity) {
    return new HemisphereLight(skyColor, groundColor, intensity);
  }
)
