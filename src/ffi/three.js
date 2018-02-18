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
var Vector3 = require("three").Vector3
var Points = require("three").Points

var OrbitControls = require('three-orbit-controls')(require("three"))

var _ = require("lodash")
// var THREE = require("Three");
// Setup scene  

const createScene = function(points) { 
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
  camera.position.set(0, 0, 450)
  camera.lookAt(0, 0, 100) 

  // Controls
  var controls = new OrbitControls(camera)
  controls.enableZoom = true;
  controls.autoRotate = true;

  // Attach canvas canvas
  document.body.appendChild( renderer.domElement );

  // "Pixels"
  // var dotGeometry = new THREE.Geometry();
  // dotGeometry.vertices.push(new THREE.Vector3(0, 0, 0));
  // var dotMaterial = new THREE.PointsMaterial( { size: 1, sizeAttenuation: false } );
  // var dot = new THREE.Points(dotGeometry, dotMaterial);
  // scene.add(dot);

  // Make pixels & position them
  // export var doPoints = points => points.forEach(({x,y,z}) => {
  //   var dotGeometry = new THREE.Geometry();
  //   dotGeometry.vertices.push(new THREE.Vector3(x, y, z));
  //   var dotMaterial = new THREE.PointsMaterial( { size: 1, sizeAttenuation: false } );
  //   var dot = new THREE.Points(dotGeometry, dotMaterial);
  //   pointsCol.push(dot);
  //   scene.add(dot);
  // });

  // var pixel = Mesh(geometry, material);
  // pixel.castShadow = true;
  // pixel.position.set(posX,posY,posZ)

  // var updatePointsPos = points => points.forEach(({x,y,z}, i) => {
  //   pointsCol[i].position.set(x,y,z)
  // })

  const dots = renderPoints(points);
  // console.log(dots)
  dots.forEach(function(dot) {scene.add(dot) });

  // Start LOOP
  function animate() {
    requestAnimationFrame( animate );
    controls.update();
    
    // updatePointsPos(JSON.parse(makeScene(i+=4)));
    renderer.render( scene, camera );
  }
  
// let i = 0;
// let pointsCol = [];
// window.pointsO = JSON.parse(makeScene(100))
// window.makeScene = makeScene
// doPoints(pointsO);
  animate();

  // Can we change this to not return and use Unit or () in purescript?
  return true;

}

// Purescript point to simple object
const unWrapPoint = function(ps_point) {
  return ps_point.value0;
}

const renderPoints = function(points) {
  var dotGeometry = new Geometry();
  var dotMaterial = new PointsMaterial( { size: 1, sizeAttenuation: false } );    

  return _.map(points, function(ps_point) {
    var point = unWrapPoint(ps_point)
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