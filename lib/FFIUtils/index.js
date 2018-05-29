exports.uncurry1 = function(fn) {
  return function(p1) {
    return function() {
      return fn(p1)
    }
  }
}

exports.uncurry2 = function(fn) {
  return function(p1) {
    return function(p2) {
      return function() {
        return fn(p1, p2)
      }
    }
  } 
}

exports.uncurry3 = function(fn) {
  return function(p1) {
    return function(p2) {
      return function(p3) {
        return function() {
          return fn(p1, p2, p3)
        }
      }
    }
  }
}

exports.uncurry4 = function(fn) {
  return function(p1) {
    return function(p2) {
      return function(p3) {
        return function(p4) {
          return function() {
            return fn(p1, p2, p3, p4)
          }
        }
      }
    }
  }
}
