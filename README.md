Purescript simple scene model and geometric operations. Simple ThreeJS bindings included.

This is a personal exploratoty project to learn more Purescript and WegGL.

See it live at [Purescript ThreeJS](https://rlucha.github.io/purescript-threejs/)

```
npm run js
npm run ps
```
Run a local server from project folder to see it move

## Project hierarchy
- Editor
  - Placeholder for a project editor in browser
- Projects
  - Graph-like scene creator & animations
- Three
  - ThreeJS bindings and utilities
- Lib
  - An algebra for 3D objects
- Main
  - Entry point

## Creating a new scene
- Create a new Projects folder with the project name
- Duplicate Main.purs of another project, set scene, camera, etc.
- Create a new Project file, import it in main
- Project should export create (Effect Project) and update functions (Effect Unit)
- create a new link in index.html
    ``` <a href="#/04" onclick="go()" class="page">04</a> ```
- create a new route in index.js

## TODO
- Use import Control.Monad.Eff.Uncurried instead of custom js-ffi
- Make udpdate functions in projects NOT perform side effects but get a collection of objects and properties and
  return a new collection of objects and properties. A consumer will use that to apply the changes
  under Eff making the scene as pure as possible. Under that idea, the project would use a DSL and a "runner" module
  would transform those into actual threejs calls.
- Make Project a graph and provide a way to traverse it (Functor Project?)
- Generalize the project file utils into a project object in Pure3
- Connect datGUI to those params to get some interactivity
- Create a set of JS utils to make IFF less painful
  - Get webpack to serve all files using purs-loader or similar
    - Will this do dead code elimination?
- Orbitcontrol rotate, autoupdate fns, enable zoom, etc.
- Write a bit of documentation about the type decisions on Timeline and Main mostly
- Pass any input value as well as frame to behaviours...
- Move camera into project?
- Add proper fog to scene instead of directly from js
- Transparent canvas color?
- Check for a way to easy the pain on wrapping unwrapping object3D
- get 2d coordinates from any element in canvas to match css elements on top
- Move projects config to a record
- move onResize event to purescript
- throttle onResize
- Replace Maintype with Effect, currently Timeline is coupled
- [NEWTYPE] Wrap / Unwrap using newtype instance for Line and other Pure3 types 
- Flip shape matrix to the ground
- Center FrameBound scene
- custom height for buildings
- get shadows to work
- create a base material object (typeclass? to deal with common properties)
- only get lines with all points inside query from osm-cutemaps
- makes some sense of the lineString geom type
- explore solutions like https://www.nextzen.org/ or https://wiki.openstreetmap.org/wiki/Overpass_API to get the data
- Finish ThreeJS bindings module structure, set placeholders for every module in the original repo
- Check lineGeometry, lineMaterial, etc.

From stackoverflow:
```
function hexToRgb(hex) {
    var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
    return result ? {
        r: parseInt(result[1], 16) / 255,
        g: parseInt(result[2], 16) / 255,
        b: parseInt(result[3], 16) / 255
    } : null;
}
```
