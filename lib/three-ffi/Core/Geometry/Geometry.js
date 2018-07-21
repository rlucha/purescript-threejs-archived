// TODO: pass configuration 
var ffi = require("ffi-utils")
var Geometry = require("three").Geometry

// this doesn't work with ffi.curry1... why?
exports.create = 
  function() {
    return new Geometry();
  }
