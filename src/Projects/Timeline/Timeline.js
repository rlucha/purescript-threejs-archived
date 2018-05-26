exports.setAnimationFrameBehaviour = function(fn) {
  return function() {
    window.requestAnimationFrame(fn)
  }
}

// TODO: This should always return an Int
exports.unsafeGetGlobalValue = function(key) {
  return function() {
    return window[key] || 0;
  }
}

exports.unsafeSetGlobalValue = function(key) {
  return function(value) {
    return function() {
      return window[key] = 0;
    }
  }
}
