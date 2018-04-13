// MODULE Three

// TODO
// Annotate everything this file is doing and move it to purescript eventually

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
var MeshNormalMaterial = require("three").MeshNormalMaterial
var Vector3 = require("three").Vector3
var Face3 = require("three").Face3
var Points = require("three").Points
var Line = require("three").Line
var Color = require("three").Color
var Mesh = require("three").Mesh
var DoubleSide = require("three").DoubleSide
var ShapeUtils = require("three").ShapeUtils
var CylinderGeometry = require("three").CylinderGeometry
var HemisphereLight = require("three").HemisphereLight

var OrbitControls = require('three-orbit-controls')(require("three"))

var _ = require("lodash")
// Setup scene  

const createScene = function(ps_scene, animationCB) { 

  const uwrap_scene = unwrapScene(ps_scene)
  window.uwrap_scene = uwrap_scene
  const ps_points = uwrap_scene.points
  const ps_lines = uwrap_scene.lines
  const ps_meshes = uwrap_scene.meshes

  var scene = new Scene();
  scene.background = new Color( 0x212741 );
  
  // DEBUG
  window.THREE = require("three")
  window.scene = scene;

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
  camera.position.set(0, 50, 80)
  camera.lookAt(0, 250, 0) 

  // Global lights
  var light = new HemisphereLight( 0xffffff, 0x080820, 1 );
  scene.add( light );

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

  const meshes = renderMeshes(ps_meshes);
  
  lines.forEach(function(line) {scene.add(line) });
  dots.forEach(function(dot) {scene.add(dot) });
  meshes.forEach(function(mesh) {scene.add(mesh) });

  const cylinders = makeCylinders(ps_points)

  const timeStamp = Date.now()
  // Start LOOP
  function animate() {
    const t = Date.now() - timeStamp
    requestAnimationFrame( animate );
    controls.update();
    renderer.render( scene, camera );
    moveCylinders(cylinders, t)
  }
  
  animate();

}

const unwrapScene = function(ps_scene) {
  const points = ps_scene.value0.points
  const lines = ps_scene.value0.lines
  const meshes = ps_scene.value0.meshes

  return { points:points , lines:lines, meshes:meshes }
}

// Purescript point to simple object
const unWrapPSField = function(ps_point) {
  return ps_point.value0;
}

const renderLines = function(ps_lines) {
  const lineMaterial = new LineBasicMaterial( { color: 0x00ffff, transparent:true } );
  lineMaterial.opacity=0.25;  
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

const makeCylinders = function(points) {
  return _.map(points, function(p) {
    return makeCylinder(unWrapPSField(p))
  })
}

const makeCylinder = function(point) {
  const sz = 8.2;
  var geometry = new CylinderGeometry(sz,sz,10,6);
  var material = new MeshNormalMaterial({side: DoubleSide})
  var cylinder = new Mesh( geometry, material );

  cylinder.position.set(point.x, 0 ,point.z)
  scene.add( cylinder );
  return cylinder
}

const moveCylinders = function(cylinders, offset) {  
  
  cylinders.forEach(function(c) {
    const posX = c.position.x
    const posZ = c.position.z
    const delta = (posX + posZ) * 0.2
    const h = Math.abs(Math.cos((posX + posZ) * offset * 0.000001) * 80);  
    c.position.set(posX, h , posZ)
  })
}

const renderMeshes = function(meshes) {
  var geometry = new Geometry();

  const mesh01 = meshes[0]
  _.forEach(mesh01, function(mesh_point) {
    var point = unWrapPSField(mesh_point)
    var x = point.x;
    var y = point.y;
    var z = point.z;

    geometry.vertices.push(new Vector3(x, y, z));
  })

  geometry.vertices.push(new Vector3(100, 0, 0))

  console.log(geometry.vertices)
  var triangles = ShapeUtils.triangulateShape(geometry.vertices, [])

  _.forEach(triangles, function(t) {
    geometry.faces.push(new Face3(t[0], t[1], t[2]))
  })


  // console.log(geometry.vertices[0], geometry.vertices[1], geometry.vertices[2])
  // geometry.faces.push( new Face3( 
  //   geometry.vertices[0],
  //   geometry.vertices[1],
  //   geometry.vertices[2]
  // ) );

  // needs faces too
  
  geometry.computeVertexNormals()

  var material = new MeshNormalMaterial({side: DoubleSide})
  var mesh = new Mesh( geometry, material );

  return [mesh]
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