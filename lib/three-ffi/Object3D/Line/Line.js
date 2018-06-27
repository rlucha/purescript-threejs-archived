var ffi = require("ffi-utils")
var Line = require("three").Line

exports.create_ = ffi.curry2(
  function(geometry, material) {
    return new Line(geometry, material);
  }
)
