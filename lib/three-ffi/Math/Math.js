var ffi = require("ffi-utils")
var ThreeMath = require("three").Math

exports.degToRad = ffi.curry1(
  function(deg) {
    return ThreeMath.degToRad(deg)
  }
)