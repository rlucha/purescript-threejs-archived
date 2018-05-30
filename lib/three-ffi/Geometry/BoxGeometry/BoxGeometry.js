var ffi = require("ffi-utils")
var BoxGeometry = require("three").BoxGeometry

exports.create = ffi.curry3(
  function(width, height, depth) {
    return new BoxGeometry(width, height, depth);
  }
)
