exports.setAnimationFrameBehaviour = function(fn) {
  return function() {
    window.requestAnimationFrame(fn)
  }
}