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

## TODO
- 01 Make Project a graph and provide a way to traverse it (Functor Project?)
- 05 Connect datGUI to those params to get some interactivity
- 06 Next steps: Try to reproduce hierarchy2 example from threejs 
- 07 Create a set of JS utils to make IFF less painful
  - Get webpack to serve all files using purs-loader or similar
  - Get to write the JS in es6 and server that to the compiler
  - Write fat arrow utility functions
- 09 Add Camera lookAt fn
- 10 Orbitcontrol rotate, autoupdate fns, enable zoom, etc.
- 11 Write a bit of documentation about the type decisions on Timeline and Main mostly
- 12 Remove most comments and create function names for those
- 13 Generalize the project file utils into a project object in Pure3
- 14 Add mousePositionValues to the project update fn input
- 15 Move camera into project?
- 16 Add proper fog to scene instead of directly from js
- 17 Transparent canvas color?
- 18 Check for a way to easy the pain on wrapping unwrapping object3D
- 19 Move camera && calculations inside scene
- 21 pass time as well as frame to behaviours...
- 22 get 2d coordinates from any element in canvas to match css elements on top
- 25 Move projects config to a record
- 26 move onResize event to purescript
- 27 throttle onResize
- 28 Replace Maintype with Effect, currently Timeline is coupled
