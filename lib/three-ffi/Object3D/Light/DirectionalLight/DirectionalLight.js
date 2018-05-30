var ffi = require("ffi-utils")
var DirectionalLight = require("three").DirectionalLight

exports.create_ = ffi.curry1(
  function(color) {
    return new DirectionalLight(color);
  }
)
