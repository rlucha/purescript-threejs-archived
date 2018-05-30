var ffi = require("ffi-utils")
var Mesh = require("three").Mesh

exports.create_ = ffi.curry2(
  function(geometry, material) {
    return new Mesh(geometry, material);
  }
)
