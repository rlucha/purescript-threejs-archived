exports.curry1 = function(fn) {
  return function(p1) {
    return function() {
      return fn(p1)
    }
  }
}

exports.curry2 = function(fn) {
  return function(p1) {
    return function(p2) {
      return function() {
        return fn(p1, p2)
      }
    }
  } 
}

exports.curry3 = function(fn) {
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

exports.curry4 = function(fn) {
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
