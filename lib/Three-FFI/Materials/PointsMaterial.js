// TODO: pass configuration 
var PointsMaterial = require("three").PointsMaterial
var Vector2 = require("three").Vector2   
var ShaderMaterial = require("three").ShaderMaterial

// exports.createPointsMaterial = function(/*cfg*/) {
//   // return new PointsMaterial({ size: 5, sizeAttenuation: true } );    
//   return new PointsMaterial({ size: 1, sizeAttenuation: false, lights: false, fog: true } );    
// }

exports.createPointsMaterial = function(/*cfg*/) {
  
  var vertexShader =   
    "varying vec4 vertexColor;" + 
    "void main() {" +
      "gl_PointSize = 2.0;" +
      "gl_Position = projectionMatrix *" +
      "              modelViewMatrix *" +
      "              vec4(position,1.0);" +
      "vertexColor = vec4(position,1.0);" +
      "  }"

  var fragmentShader =
  " varying lowp vec4 vertexColor;" + 
  "   uniform vec2 u_resolution;" + 
  "   uniform vec2 u_mouse;" + 
  "   uniform float u_time;" + 
  "   void main(){" + 
  "     gl_FragColor = " +
  // "       vec4((vertexColor.y * 0.020) + 0.99, (vertexColor.y * 0.020) + 0.99, (vertexColor.y * 0.020) + 0.99, 0);" + 
  "          vec4( " +
  "              ((1200.0 + vertexColor.z) * 0.0025 + 0.25) /* * 255.0 / 255.0 */, " +
  "              ((1200.0 + vertexColor.z) * 0.0025 + 0.25) /* * 208.0 / 255.0 */, " +
  "              ((1200.0 + vertexColor.z) * 0.0025 + 0.25) /* * 194.0 / 255.0 */, " +
  "              1);" + 
  "   }" 

var uniforms = { 
  u_time: { type: 'f', value: 0 },
  u_resolution: { type: 'v2', value: new Vector2() },
  u_mouse: { type: 'v2', value: new Vector2() }
}

var shaderMaterial = new ShaderMaterial({
  uniforms: uniforms,
  vertexShader: vertexShader,
  fragmentShader: fragmentShader
})
  return shaderMaterial
}
