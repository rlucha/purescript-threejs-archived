var AmbientLight = require("three").AmbientLight

exports.create_ = function(color) {
    return function() {
      return new AmbientLight(color, 0.75);
    }
}
