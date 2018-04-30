// // MODULE Three

var Color = require("three").Color

// // TODO
// // Annotate everything this file is doing and move it to purescript eventually

// // It seems there is a limitation with foreign modules and node require..
// // Maybe we can createa bundle previously and expose the rollup build to purescript?

// module.exports = {
//   Scene: require("three").Scene
// }

// var Scene = require("three").Scene
// var WebGLRenderer = require("three").WebGLRenderer
// var AmbientLight = require("three").AmbientLight
// var SpotLight = require("three").SpotLight
// var AxesHelper = require("three").AxesHelper
// var PerspectiveCamera = require("three").PerspectiveCamera
// var Mesh = require("three").Mesh
// var Geometry = require("three").Geometry
// var PointsMaterial = require("three").PointsMaterial
// var LineBasicMaterial = require("three").LineBasicMaterial
// var MeshNormalMaterial = require("three").MeshNormalMaterial
// var MeshPhongMaterial = require("three").MeshPhongMaterial
// var Vector3 = require("three").Vector3
// var Face3 = require("three").Face3
// var Points = require("three").Points
// var Line = require("three").Line
// var Color = require("three").Color
// var Mesh = require("three").Mesh
// var DoubleSide = require("three").DoubleSide
// var ShapeUtils = require("three").ShapeUtils
// var CylinderGeometry = require("three").CylinderGeometry
// var HemisphereLight = require("three").HemisphereLight
// var OrthographicCamera = require("three").OrthographicCamera
// var Fog = require("three").Fog

// var OrbitControls = require('three-orbit-controls')(require("three"))

// var _ = require("lodash")
// // Setup scene  

// const sceneConfig = {
//   cylinderSize: 25,
//   waveAmplitude: 10,
//   waveSpeed: 0.0015,
//   waveFrequency: 0.005,
//   colors: {
//     background: new Color(0x211E2B),
//     color1: new Color(0x9C4368),
//     color2: new Color(0xE36D60),
//     color3: new Color(0xED8F5B),
//     color4: new Color(0x33223B),  
//   }
// }

// const createScene = function(ps_scene) { 
//   return function() {
//     const uwrap_scene = unwrapScene(ps_scene)
//     window.uwrap_scene = uwrap_scene
//     const ps_points = uwrap_scene.points
//     const ps_lines = uwrap_scene.lines
//     const ps_meshes = uwrap_scene.meshes
  
//     // :scene
//     var scene = new Scene();
//     scene.background = sceneConfig.colors.background
//     // How to make fog appear?
//     // :fog
//     scene.fog = new Fog(sceneConfig.colors.background, 0.015, 600);
    
//     // DEBUG
//     window.THREE = require("three")
//     window.scene = scene;
  
//     // Renderer
//     var renderer = new WebGLRenderer();
//     renderer.setPixelRatio( window.devicePixelRatio );
//     renderer.setSize( window.innerWidth, window.innerHeight );
  
//     var ambientLight = new AmbientLight(0x404040);
//     scene.add(ambientLight);
  
//     var spotLight = new SpotLight();
//     spotLight.position.set(500, 1000, 1000);
//     spotLight.power = 3;
//     spotLight.castShadow = true;
//     scene.add(spotLight);
  
//     // Axis helper
//     // var axesHelper = new AxesHelper( 100 );
//     // scene.add( axesHelper );
    
//     // :camera
//     var camera = new PerspectiveCamera( 100, window.innerWidth / window.innerHeight, 1, 1000 );
//     // var camera = new OrthographicCamera( 1000 / - 2, 1000 / 2, 800 / 2, 800 / - 2, 1, 1000 );
    
//     camera.position.set(-112, 170, 60)
//     camera.lookAt(0, 0, 0) 
  
//     // Global lights
//     var light = new HemisphereLight( 0xffffff, 0x080820, 1 );
//     scene.add( light );
  
//     // Controls
//     var controls = new OrbitControls(camera)
//     controls.enableZoom = true;
//     controls.enabled = true;
//     // controls.autoRotate = true;
  
//     // Attach canvas canvas
//     document.body.appendChild( renderer.domElement );
  
//     const dots = renderPoints(ps_points);
    
//     // TODO add lines
//     const lines = renderLines(ps_lines);
  
//     const meshes = renderMeshes(ps_meshes);
    
//     lines.forEach(function(line) {scene.add(line) });
//     dots.forEach(function(dot) {scene.add(dot) });
//     meshes.forEach(function(mesh) {scene.add(mesh) });
  
//     const cylinders = makeCylinders(ps_points)
  
//     const timeStamp = Date.now()
//     // Start LOOP
//     function animate() {
//       const t = Date.now() - timeStamp
//       requestAnimationFrame( animate );
//       controls.update();
//       renderer.render( scene, camera );
//       moveCylinders(cylinders, t)
//     }
    
//     animate();
//   }
// }

// const unwrapScene = function(ps_scene) {
//   const points = ps_scene.value0.points
//   const lines = ps_scene.value0.lines
//   const meshes = ps_scene.value0.meshes

//   return { points:points , lines:lines, meshes:meshes }
// }

// // Purescript point to simple object
// const unWrapPSField = function(ps_point) {
//   return ps_point.value0;
// }

// const renderLines = function(ps_lines) {
//   const lineMaterial = new LineBasicMaterial( { color: 0x00ffff, transparent:true } );
//   lineMaterial.opacity=0.25;  
//   const lineGeometry = new Geometry();

//   return _.map(ps_lines, function(ps_line) { 
//     // automate unwrapLine / recursive ?
//     const line = unWrapPSField(ps_line)
//     const la = unWrapPSField(line.a)
//     const lb = unWrapPSField(line.b)
//     lineGeometry.vertices.push(new Vector3( la.x, la.y, la.z) );
//     lineGeometry.vertices.push(new Vector3( lb.x, lb.y, lb.z) );
//     var three_line = new Line( lineGeometry, lineMaterial );
//     return three_line;
//   })
// }

// const makeCylinders = function(points) {
//   return _.map(points, function(p) {
//     return makeCylinder(unWrapPSField(p))
//   })
// }

// const makeCylinder = function(point) {
//   const sz = sceneConfig.cylinderSize;
//   var geometry = new CylinderGeometry(sz,sz,10,6);
//   // var material = new MeshNormalMaterial({side: DoubleSide})
//   var material = new MeshPhongMaterial({
//     color: sceneConfig.colors.color1,
//     opacity: 1.0,
//     transparent: true
//   })
//   var cylinder = new Mesh( geometry, material );

//   cylinder.position.set(point.x, 0 ,point.z)
//   scene.add( cylinder );
//   return cylinder
// }

// const moveCylinders = function(cylinders, t) {  
//   const speed = t * sceneConfig.waveSpeed;
//   const amplitude = sceneConfig.waveAmplitude;
//   const freq = sceneConfig.waveFrequency

//   cylinders.forEach(function(c) {
//     const posX = c.position.x
//     const posZ = c.position.z
//     const delta = (posX + posZ) * freq
//     // const h = Math.abs(Math.cos((posX + posZ) * t * 0.00001) * 80);  
//     const h = Math.cos(speed + delta) * amplitude
//     c.position.set(posX, h , posZ)
//   })
// }

// const renderMeshes = function(meshes) {
//   var geometry = new Geometry();

//   const mesh01 = meshes[0]
//   _.forEach(mesh01, function(mesh_point) {
//     var point = unWrapPSField(mesh_point)
//     var x = point.x;
//     var y = point.y;
//     var z = point.z;

//     geometry.vertices.push(new Vector3(x, y, z));
//   })

//   geometry.vertices.push(new Vector3(100, 0, 0))

//   var triangles = ShapeUtils.triangulateShape(geometry.vertices, [])

//   _.forEach(triangles, function(t) {
//     geometry.faces.push(new Face3(t[0], t[1], t[2]))
//   })

//   geometry.computeVertexNormals()

//   var material = new MeshNormalMaterial({side: DoubleSide})
//   var mesh = new Mesh( geometry, material );

//   return [mesh]
// }

// const renderPoints = function(points) {
//   var dotGeometry = new Geometry();
//   var dotMaterial = new PointsMaterial( { size: 1, sizeAttenuation: false } );    

//   return _.map(points, function(ps_point) {
//     var point = unWrapPSField(ps_point)
//     var x = point.x;
//     var y = point.y;
//     var z = point.z;

//     dotGeometry.vertices.push(new Vector3(x, y, z));
//     var dot = new Points(dotGeometry, dotMaterial);
//     return dot;
//     // pointsCol.push(dot);
//   })
// };

// module.exports = {
//   createScene: createScene,
//   renderPoints: renderPoints
// }

// // export const doPoints = points => points.forEach(({x,y,z}) => {
// //   var dotGeometry = new THREE.Geometry();
// //   dotGeometry.vertices.push(new THREE.Vector3(x, y, z));
// //   var dotMaterial = new THREE.PointsMaterial( { size: 1, sizeAttenuation: false } );
// //   var dot = new THREE.Points(dotGeometry, dotMaterial);
// //   pointsCol.push(dot);
// //   scene.add(dot);
// // });


// Simple string implementation for color, no checks...
var createColor = function(color) {
  return function() {
    return new Color(color)
  }
}

module.exports = {
  createColor: createColor
}