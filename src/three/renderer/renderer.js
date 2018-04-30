var curry = require('lodash.curry');

var WebGLRenderer = require("three").WebGLRenderer

var createWebGLRenderer = function() {
  return new WebGLRenderer()
}

// TODO: make this get a param from window
var setPixelRatio = function(renderer) {
  return function() {
    renderer.setPixelRatio( window.devicePixelRatio)
    return renderer
  }
}

// TODO: Use something like Ramda curry fn to make this easy
// window.innerWidth, window.innerHeight
var setSize = function(width) {
  return function(height) {
    return function(renderer) {
      return function() {
        renderer.setSize( width, height)
        return renderer  
      }
    }
  }
}

var setSize2 = curry(setSize)

window.setSize = setSize
window.setSize2 = setSize2

var mountRenderer = function(renderer) {
  return function() {
    document.body.appendChild( renderer.domElement);
  }
}


module.exports = {
  createWebGLRenderer: createWebGLRenderer,
  setPixelRatio: setPixelRatio,
  setSize: setSize,
  mountRenderer: mountRenderer
}
