// MODULE Three


// It seems there is a limitation with foreign modules and node require..
// Maybe we can createa bundle previously and expose the rollup build to purescript?

var Scene = require("three").Scene
var WebGLRenderer = require("three").WebGLRenderer
var AmbientLight = require("three").AmbientLight
var SpotLight = require("three").SpotLight
var AxesHelper = require("three").AxesHelper
var PerspectiveCamera = require("three").PerspectiveCamera
var Mesh = require("three").Mesh
var Geometry = require("three").Geometry
var PointsMaterial = require("three").PointsMaterial
var LineBasicMaterial = require("three").LineBasicMaterial
var Vector3 = require("three").Vector3
var Points = require("three").Points
var Line = require("three").Line

var OrbitControls = require('three-orbit-controls')(require("three"))

var _ = require("lodash")
// Setup scene  

const createScene = function(ps_scene, animationCB) { 

  const uwrap_scene = unwrapScene(ps_scene)
  const ps_points = uwrap_scene.points
  const ps_lines = uwrap_scene.lines

  var scene = new Scene();

  // Renderer
  var renderer = new WebGLRenderer();
  renderer.setPixelRatio( window.devicePixelRatio );
  renderer.setSize( window.innerWidth, window.innerHeight );

  var ambientLight = new AmbientLight(0x404040);
  scene.add(ambientLight);

  var spotLight = new SpotLight();
  spotLight.position.set(500, 1000, 1000);
  spotLight.power = 3;
  spotLight.castShadow = true;
  scene.add(spotLight);

  // Axis helper
  var axesHelper = new AxesHelper( 100 );
  scene.add( axesHelper );

  
  // Camera
  var camera = new PerspectiveCamera( 60, window.innerWidth / window.innerHeight, 1, 1000 );
  camera.position.set(-100, 50, 200)
  camera.lookAt(0, 0, 0) 

  window.camera = camera;
  // Controls
  var controls = new OrbitControls(camera)
  controls.enableZoom = true;
  controls.enabled = true;
  // controls.autoRotate = true;

  // Attach canvas canvas
  document.body.appendChild( renderer.domElement );

  const dots = renderPoints(ps_points);
  
  // TODO add lines
  const lines = renderLines(ps_lines);
  
  lines.forEach(function(line) {scene.add(line) });
  dots.forEach(function(dot) {scene.add(dot) });

  // Start LOOP
  function animate() {
    requestAnimationFrame( animate );
    controls.update();
    renderer.render( scene, camera );
  }
  
  animate();

}

const unwrapScene = function(ps_scene) {
  const points = ps_scene.value0.points
  const lines = ps_scene.value0.lines

  return {points:points , lines:lines}
}

// Purescript point to simple object
const unWrapPSField = function(ps_point) {
  return ps_point.value0;
}

const renderLines = function(ps_lines) {
  const lineMaterial = new LineBasicMaterial( { color: 0x00ffff } );
  const lineGeometry = new Geometry();

  return _.map(ps_lines, function(ps_line) { 
    // automate unwrapLine / recursive ?
    const line = unWrapPSField(ps_line)
    const la = unWrapPSField(line.a)
    const lb = unWrapPSField(line.b)
    lineGeometry.vertices.push(new Vector3( la.x, la.y, la.z) );
    lineGeometry.vertices.push(new Vector3( lb.x, lb.y, lb.z) );
    var three_line = new Line( lineGeometry, lineMaterial );
    return three_line;
  })
}

const renderPoints = function(points) {
  var dotGeometry = new Geometry();
  var dotMaterial = new PointsMaterial( { size: 1, sizeAttenuation: false } );    

  return _.map(points, function(ps_point) {
    var point = unWrapPSField(ps_point)
    var x = point.x;
    var y = point.y;
    var z = point.z;

    dotGeometry.vertices.push(new Vector3(x, y, z));
    var dot = new Points(dotGeometry, dotMaterial);
    return dot;
    // pointsCol.push(dot);
  })
};



module.exports = {
  createScene: createScene,
  renderPoints: renderPoints
}

// export const doPoints = points => points.forEach(({x,y,z}) => {
//   var dotGeometry = new THREE.Geometry();
//   dotGeometry.vertices.push(new THREE.Vector3(x, y, z));
//   var dotMaterial = new THREE.PointsMaterial( { size: 1, sizeAttenuation: false } );
//   var dot = new THREE.Points(dotGeometry, dotMaterial);
//   pointsCol.push(dot);
//   scene.add(dot);
// });