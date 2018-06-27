var ffi = require("ffi-utils")
var PlaneGeometry = require("three").PlaneGeometry

exports.create = ffi.curry4(
  function(width, height, width_segments, height_segments) {
    return new PlaneGeometry(width, height, width_segments, height_segments);
  }
)