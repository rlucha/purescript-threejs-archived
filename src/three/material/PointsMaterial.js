// TODO: pass configuration 
var PointsMaterial = require("three").PointsMaterial

exports.createPointsMaterial = function(/*cfg*/) {
  return new PointsMaterial({ size: 1, sizeAttenuation: false } );    
}