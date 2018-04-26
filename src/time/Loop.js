// fns is equivalent to mainLoop flist missing n (t)
// fns will be passed as a function that expect a number and returns a list of
// functions that expect a number (but in a closure with the number as context)
// then we call those functions to perform all the effects given t

var setAnimationFrameBehaviour = function(fns) {
  var requestAnimationFrame_ = function(t) {
    fns(t).forEach(function(fn) { fn() })
    window.requestAnimationFrame(requestAnimationFrame_)
  } 
  requestAnimationFrame_(0)
  // Avoids PS["Main"].main() not being a function
  return function() {}
}

exports.setAnimationFrameBehaviour = setAnimationFrameBehaviour