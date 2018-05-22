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
- Connect datGUI to those params to get some interactivity
- Next steps: Try to reproduce hierarchy2 example from threejs 
- Create a set of JS utils to make IFF less painful
  - Get webpack to serve all files using purs-loader or similar
  - Get to write the JS in es6 and server that to the compiler
  - Write fat arrow utility functions
- Change it on resize, updateMatrices
- Add Camera lookAt fn
- Orbitcontrol rotate, autoupdate fns, enable zoom, etc.
- Write a bit of documentation about the type decisions on Timeline and Main mostly
- Remove most comments and create function names for those
- Generalize the project file utils into a project object in Pure3
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
