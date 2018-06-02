// // MODULE Three

var Color = require("three").Color
var AxesHelper = require("three").AxesHelper
var Geometry = require("three").Geometry
var Vector3 = require("three").Vector3

// Simple string implementation for color, no checks...
exports.createColor = function(color) {
  return function() {
    return new Color(color)
  }
}

exports.createAxesHelper = function(size) {
  return function() {
    return new AxesHelper(size)
  }
}

exports.createGeometry = function() {
  return new Geometry()
} 

// Vector3
exports.createVector3 = function (x) {
  return function(y) {
    return function(z) {
      return function() {
        return new Vector3(x, y, z)
      }
    }
  }
}

exports.getVector3Position = function(vs) {
  return function() {
    return {
      x:vs.x,
      y:vs.y,
      z:vs.z
    }
  }
}

exports.updateVector3Position = function(x) {
  return function(y) {
    return function(z) {
      return function(v3) {
        return function() {
          v3.x = x
          v3.y = y
          v3.z = z
        }
      }
    }
  }
}

// how to make this actually inmutable, manage this ref handling from PS instead of JS
exports.pushVertices = function(geometry) {
  return function(vector3) {
    return function() {
      geometry.vertices.push(vector3)
      return geometry
    }
  }
} 

// Todo use DOM to abstract this to any event and use it directly from PS
exports.onDOMContentLoaded = function(cb) {
  return function() {
    document.addEventListener("DOMContentLoaded", cb)
  }
}

exports.onResize = function(cb) {
  return function() {
    window.addEventListener("resize", cb)
  }
}

// debug function
exports.voidEff = function() {
  return function() {
  }
}
