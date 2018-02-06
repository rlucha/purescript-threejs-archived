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

const ambientLight = new THREE.AmbientLight(0x090909);
scene.add(ambientLight);


var spotLight = new THREE.SpotLight();
spotLight.position.set(10, 80, 200);
spotLight.castShadow = true;
scene.add(spotLight);


// Camera
const camera = new THREE.PerspectiveCamera( 60, window.innerWidth / window.innerHeight, 1, 1000 );
camera.position.set(0, 0, 500)
camera.lookAt(0, 0, 0)

// Controls
const controls = new OrbitControls(camera)
controls.enableZoom = true;
controls.autoRotate = true;


// Attach canvas canvas
document.body.appendChild( renderer.domElement );

// Scene data prep
const sceneData = JSON.parse(sceneJSON);

var geometry = new THREE.BoxGeometry(1, 1, 1);

var matProps = {
  specular: '#a9fcff',
  color: '#00abb1',
  emissive: '#006063',
  shininess: 10
}

var material = new THREE.MeshPhongMaterial(matProps);

// Make pixels & position them
export const doPoints = points => points.forEach(({x,y,z}) => {
  var pixel = new THREE.Mesh( geometry, material);
  pixel.castShadow = true;
  pixel.position.set(x,y,z)
  scene.add( pixel );
});

// Start LOOP
function animate() {
  requestAnimationFrame( animate );
  controls.update();
	renderer.render( scene, camera );
}

animate();
doPoints(sceneData);