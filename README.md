Purescript simple scene model and geometric operations. 

See it live at [Purescript ThreeJS](https://rlucha.github.io/purescript-threejs/)

Renders using Three.js 

```
npm run start:dev:js
npm run start:dev:ps
```

open localhost:8080


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

##TODO
- 01 Make Project a graph and provide a way to traverse it
- 02 Make results a record and provide a way to hook propery results -> Needs understading row ypes better
- 03 Remove all partial unsafe functions -> needs 02
- 04 getting 02 
- Remove any dependency from the lib module to the three module
- Connect datGUI to those params to get some interactivity
- Next steps: Try to reproduce hierarchy2 example from threejs 
- Create a set of JS utils to make IFF less painful
- Change it on resize, updateMatrices
- Add Camera lookAt fn
- Create a draft of a type structure for threeJS (Object3D, Material, etc.)
- Orbitcontrol rotate, autoupdate fns, enable zoom, etc.
- Write a bit of documentation about the type decisions on Timeline and Main mostly
- Remove most comments and create function names for those
- Generalize the project file utils into a project object in Pure3
- TODO documentReady to begin all computation, that will get proper body height values
- onDOMcontentloaded example purescript-browser-dom/src/Browser/DOM.purs
- Add mousePositionValues to the project update fn input
- Move camera into project?
- Add proper fog to scene instead of directly from js
- Transparent canvas color?
- Check for a way to easy the pain on wrapping unwrapping object3D
- Move camera && calculations inside scene
- Simplify timeline to just execute behaviours & time unbound effects
- pass time as well as frame to behaviours...
- get 2d coordinates from any element in canvas to match css elements on top
- create events that snapshot time or frame and ease on the diff from initial to duration...
- Avoid unwrapping / wrapping on Object3D.purs

