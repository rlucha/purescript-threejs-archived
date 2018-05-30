var HemisphereLight = require("three").HemisphereLight

exports.create_ = function(color) {
    return function() {
      return new HemisphereLight('0x333399', '0x00ff00', 0.5);
    }
}
