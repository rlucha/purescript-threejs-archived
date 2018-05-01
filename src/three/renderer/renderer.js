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

// Had to force this to take a number that doesn't need
var render = function(scene) {
  return function (camera) {
    return function(renderer) {
      return function() {
        console.log('render');
        
        renderer.render(scene, camera)
      }
    }  
  }
}

var mountRenderer = function(renderer) {
  return function() {
    document.body.appendChild( renderer.domElement);
  }
}


module.exports = {
  createWebGLRenderer: createWebGLRenderer,
  setPixelRatio: setPixelRatio,
  setSize: setSize,
  mountRenderer: mountRenderer,
  render: render
}
