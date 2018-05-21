exports.setPosition_ = function(x) {
  return function(y) {
    return function(z) {
      return function(object3D) {
        return function() {
          object3D.position.set(x,y,z)
        }
      }
    }
  }
}

exports.setRotation_ = function(x) {
  return function(y) {
    return function(z) {
      return function(object3D) {
        return function() {
          object3D.rotation.set(x,y,z)
        }
      }
    }
  }
}


// TODO change for a generic Object3D
exports.forceVerticesUpdate_ = function(g) {
  return function() {
    // remove .geometry and make access direct from PS
    g.geometry.verticesNeedUpdate = true
  }
}

exports.getPosition_ = function(object3D) {
  return function() {
    return object3D.position
  }
}
