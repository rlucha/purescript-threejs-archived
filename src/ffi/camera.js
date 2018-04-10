var PerspectiveCamera = require("three").PerspectiveCamera
var OrbitControls = require('three-orbit-controls')(require("three"))

var camera = new PerspectiveCamera( 60, window.innerWidth / window.innerHeight, 1, 1000 );
camera.position.set(-100, 50, 200)
camera.lookAt(0, 0, 0) 

var controls = new OrbitControls(camera)
controls.enableZoom = true;
controls.enabled = true;
controls.autoRotate = true;

module.exports = {camera, controls}