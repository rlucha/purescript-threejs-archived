module Main where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)
import Data.Int (toNumber)
import Data.Tuple (Tuple(..), fst)
import Data.Array (unsafeIndex)
import Partial.Unsafe (unsafePartial)
import Math (cos) as Math

import Timeline (create, Frame(..)) as Timeline

import Three (createColor, createAxesHelper) as T3
import Three.Types (Camera, Renderer, Scene, Three, ThreeEff)
import Three.Scene (debugScene, createScene, setSceneBackground, addToScene) as T3.Scene
import Three.Renderer (createWebGLRenderer, setPixelRatio, setSize, mountRenderer, render) as T3.Renderer
import Three.Camera (createPerspectiveCamera) as T3.Camera
import Three.OrbitControls (OrbitControls, createOrbitControls, enableControls, updateControls) as T3.Controls

import Projects.DotMatrix  as DotMatrix

incT :: Timeline.Frame -> Number
incT (Timeline.Frame n) = toNumber(n + 1) / 100.0

cosT :: Timeline.Frame -> Number
cosT (Timeline.Frame n) = Math.cos(toNumber(n) * 0.01)

createRenderer :: ThreeEff Renderer
createRenderer = do
  r <- T3.Renderer.createWebGLRenderer 
  T3.Renderer.setPixelRatio r -- Defaults to device ratio right now
  T3.Renderer.setSize 1200.0 600.0 r
  pure r

initScene :: ThreeEff (Tuple Scene DotMatrix.Project)
initScene = do 
  scene <- T3.Scene.createScene
  project <- DotMatrix.create
  T3.Scene.addToScene (DotMatrix.getProjectObjects project) scene
  T3.createColor "#000000" >>= \c -> T3.Scene.setSceneBackground c scene
  pure $ Tuple scene project

attachAxesHelper :: Scene -> Number -> ThreeEff Unit
attachAxesHelper scene size = do
  axesHelper <- T3.createAxesHelper size
  T3.Scene.addToScene axesHelper scene

createControls :: Camera -> Scene -> ThreeEff T3.Controls.OrbitControls
createControls camera scene = do 
  controls <- T3.Controls.createOrbitControls camera
  T3.Controls.enableControls controls
  pure controls

updateScene :: ∀ e. DotMatrix.Project -> Camera -> Renderer -> Array Number -> Eff (three :: Three | e) Unit
updateScene s c r t = do
-- Just while developing!! dangerous!
  DotMatrix.update s (unsafePartial $ unsafeIndex t 1)
-- the whole init function should be doing a lot of stuff by default
-- without us having to pass render or updatecontrol stuff
-- basically we should declare module effects and init should pick those up
-- and merge them with the default ones...
-- TODO Provide an interface to run loop with just the custom things
-- TODO remove this Tuple Tuple Scene DotMatrix.Project

init :: ∀ e. T3.Controls.OrbitControls -> Tuple Scene DotMatrix.Project -> Camera -> Renderer -> ThreeEff Unit
init controls (Tuple scene project) camera renderer = 
  Timeline.create calculations behaviours effects (Timeline.Frame 0)
    where 
      calculations = [incT, cosT]
      behaviours = [updateScene project camera renderer]
      effects = 
        [ T3.Controls.updateControls controls
        , T3.Renderer.render scene camera renderer ]

main :: ∀ e. Eff (three :: Three, console :: CONSOLE | e) Unit
main = do
  scene <- initScene
  camera <- T3.Camera.createPerspectiveCamera 100.0 2.0 1.0 10000.0
  renderer <- createRenderer
  controls <- createControls camera (fst scene)
  -- Utils
  _ <- attachAxesHelper (fst scene) 100.0
  _ <- T3.Scene.debugScene (fst scene) 
  T3.Renderer.mountRenderer renderer
  -- Main loop
  init controls scene camera renderer

-- TODO:
-- 01 Make Project a graph and provide a way to traverse it
-- 02 Make results a record and provide a way to hook propery results -> Needs understading row types better
-- 03 Remove all partial unsafe functions -> needs 02
-- Remove any dependency from the lib module to the three module
-- Connect datGUI to those params to get some interactivity
-- Think about other UI for inputs
-- Next steps: Try to reproduce hierarchy2 example from threejs 
-- Create a set of JS utils to make IFF less painful
-- Get canvas size from window size
-- Change it on resize, updateMatrices
-- Remove Tuple Scene DotMatrix.Project everywhere and treat them separatedly
-- Add Camera position set and camera lookAt fns
-- Create a draft of a type structure for threeJS (Object3D, Material, etc.)
-- Orbitcontrol rotate, autoupdate fns, enable zoom, etc.
-- Decide if effectful functions should return the object modified or just Unit...
-- Move updateVector3Position to PS, (make it change x y z?)
-- Make Timeline.Frame a newtype
-- Write a bit of documentation about the type decisions on Timeline.Frame.Loop and Main mostly
-- Remove most comments and create function names for those




