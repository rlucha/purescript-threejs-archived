var DirectionalLight = require("three").DirectionalLight

exports.create_ = function(color) {
    return function() {
      return new DirectionalLight(color);
    }
}
