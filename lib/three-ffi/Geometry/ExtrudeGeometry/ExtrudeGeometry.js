var ffi = require("ffi-utils")
var ExtrudeGeometry = require("three").ExtrudeGeometry

// TODO: pass extrudeSettings as 2nd param
exports.create = ffi.curry2(
  function(depth, shape) {
    return new ExtrudeGeometry(shape, {
      steps: 1,
      depth: depth,
      bevelEnabled: false
    });
  }
)
