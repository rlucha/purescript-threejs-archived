// TODO: pass configuration 
var PointsMaterial = require("three").PointsMaterial

exports.create = function(/*cfg*/) {
  // return new PointsMaterial({ size: 5, sizeAttenuation: true } );    
  return new PointsMaterial({ size: 1, sizeAttenuation: false, lights: false, fog: true } );    
}
