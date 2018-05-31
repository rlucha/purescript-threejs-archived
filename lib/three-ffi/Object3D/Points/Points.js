var ffi = require("ffi-utils")
var Points = require("three").Points

exports.create_ = ffi.curry2(
  function(geometry, material) {
    return new Points(geometry, material);
  }
)
