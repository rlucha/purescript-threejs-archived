import * as THREE from 'three'
// import OrbitControls from 'three-orbit-controls';

// OrbitControls(THREE)
var OrbitControls = require('three-orbit-controls')(THREE)

import { sceneJSON } from '../output/Main';  

// Setup scene
const scene = new THREE.Scene();

// Renderer
const renderer = new THREE.WebGLRenderer();
renderer.setPixelRatio( window.devicePixelRatio );
renderer.setSize( window.innerWidth, window.innerHeight );

// Camera
const camera = new THREE.PerspectiveCamera( 60, window.innerWidth / window.innerHeight, 1, 1000 );
camera.position.set(0, 0, 500)
camera.lookAt(new THREE.Vector3())

// Controls

const controls = new OrbitControls(camera)
// controls.addEventListener( 'change', render ); // remove when using animation loop
// enable animation loop when using damping or autorotation
//controls.enableDamping = true;
//controls.dampingFactor = 0.25;
controls.enableZoom = false;

// Attach canvas canvas
document.body.appendChild( renderer.domElement );

// Scene data prep
const sceneData = JSON.parse(sceneJSON);

var geometry = new THREE.BoxGeometry(1, 1, 1);
var material = new THREE.MeshBasicMaterial( { color: 0xffffff } );

// Make pixels & position them
export const doPoints = points => points.forEach(({x,y}) => {
  var pixel = new THREE.Mesh( geometry, material);
  pixel.position.set(x,y,0)
  scene.add( pixel );
});

// Start LOOP
function animate() {
	requestAnimationFrame( animate );
	renderer.render( scene, camera );
}

animate();
doPoints(sceneData);