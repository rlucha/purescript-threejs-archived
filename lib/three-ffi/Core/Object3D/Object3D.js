var ffi = require("ffi-utils");

exports.setPosition_ = function(x) {
  return function(y) {
    return function(z) {
      return function(object3D) {
        return function() {
          object3D.position.set(x, y, z);
        };
      };
    };
  };
};

exports.setRotation_ = function(x) {
  return function(y) {
    return function(z) {
      return function(object3D) {
        return function() {
          object3D.rotation.set(x, y, z);
        };
      };
    };
  };
};

exports.setScale_ = function(x) {
  return function(y) {
    return function(z) {
      return function(object3D) {
        return function() {
          object3D.scale.set(x, y, z);
        };
      };
    };
  };
};

exports.rotateOnAxis_ = function(v3) {
  return function(angle) {
    return function(object3D) {
      return function() {
        object3D.rotateOnAxis(v3, angle);
      };
    };
  };
};

// TODO change for a generic Object3D
exports.forceVerticesUpdate_ = function(g) {
  return function() {
    // remove .geometry and make access direct from PS
    g.geometry.verticesNeedUpdate = true;
  };
};

exports.getPosition_ = function(object3D) {
  return function() {
    return object3D.position;
  };
};

exports.setReceiveShadow_ = ffi.curry2(function(bool, object3D) {
  object3D.receiveShadow = bool;
});

exports.setCastShadow_ = ffi.curry2(function(bool, object3D) {
  object3D.castShadow = bool;
});
