var ffi = require("ffi-utils")
var AmbientLight = require("three").AmbientLight

// TODO: Make this accept intensity too
exports.create_ = ffi.curry1(
  function(color) {
    return new AmbientLight(color, 0.75);
  }
)
