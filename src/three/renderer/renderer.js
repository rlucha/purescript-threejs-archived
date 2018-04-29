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
// Check if the currying here affects anything outside
// window.innerWidth, window.innerHeight
var setSize = curry(function(renderer, width, height, _) {
  renderer.setSize( width, height)
  return renderer  
})

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
