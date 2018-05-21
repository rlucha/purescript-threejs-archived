module Main where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)
import Data.Int (toNumber)
import Data.Array (unsafeIndex)
import Partial.Unsafe (unsafePartial)
import Data.Maybe
import Data.Tuple (Tuple(..), fst, snd)
import Data.Traversable (traverse_)
import Math (cos) as Math

import DOM (DOM)
import DOM.HTML (window)
import DOM.HTML.Window (document)
import DOM.HTML.Document (body)
import DOM.HTML.HTMLElement (offsetWidth, offsetHeight)
import DOM.Event.EventTarget
import DOM.Event.Types (EventTarget, Event, EventType(..))

import Timeline (create, Frame(..)) as Timeline

import Three (createColor, createAxesHelper, onDOMContentLoaded) as Three
import Three.Types (Camera, Renderer, Scene, Three, ThreeEff)
import Three.Scene (debugScene, createScene, setSceneBackground, addToScene) as Scene
import Three.Renderer (createWebGLRenderer, setPixelRatio, setSize, mountRenderer, render) as Renderer
import Three.Camera (createPerspectiveCamera, debugCamera, setCameraPosition) as Camera
import Three.OrbitControls (OrbitControls, createOrbitControls, toggleControls, updateControls) as Controls

import Projects.CircleStuff  as CircleStuff

incT :: Timeline.Frame -> Number
incT (Timeline.Frame n) = toNumber(n + 1) / 100.0

cosT :: Timeline.Frame -> Number
cosT (Timeline.Frame n) = Math.cos(toNumber(n) * 0.01)

unsafeGetAspectRatio :: ∀ e. Eff (three :: Three, dom :: DOM | e) Number
unsafeGetAspectRatio = do
  bs <- unsafeGetBodySize
  pure ((fst bs) / (snd bs))

unsafeGetBodySize :: ∀ e. Eff (three :: Three, dom :: DOM | e) (Tuple Number Number)
unsafeGetBodySize = do
  w <- window
  d <- document w
  b <- body d
  case b of
    Just b' -> do
      bw <- offsetWidth b'
      bh <- offsetHeight b'
      pure $ Tuple bw bh
    -- TODO: On Nothing, cause exception
    Nothing -> do 
      pure $ Tuple 0.0 0.0

createRenderer :: ∀ e. Eff (three :: Three, dom :: DOM | e) Renderer
createRenderer = do
  bs <- unsafeGetBodySize
  r <- Renderer.createWebGLRenderer 
  Renderer.setPixelRatio r
  Renderer.setSize (fst bs) (snd bs) r
  pure r

initScene :: ThreeEff Scene
initScene = do 
  scene <- Scene.createScene
  bgColor <- Three.createColor "#000000"
  Scene.setSceneBackground bgColor scene
  pure scene

attachAxesHelper :: Scene -> Number -> ThreeEff Unit
attachAxesHelper scene size = do
  axesHelper <- Three.createAxesHelper size
  Scene.addToScene scene axesHelper

createControls :: Camera -> Scene -> ThreeEff Controls.OrbitControls
createControls camera scene = do 
  controls <- Controls.createOrbitControls camera
  Controls.toggleControls true controls
  pure controls

-- updateScene should pass the entire Array Number to the Project and let the project decide
-- what to pick
-- at the same time... it is a bit weird that the project picks some
-- calculations from outside of itself instead of inside...
-- It makes the project dependant on the Timeline payload `Array Number`
-- I think the scene should be the one doing its own calculations, and behaviours should only pick t
-- Then we can provide a common set of calculations from time in a module that can be shared between projects
updateScene :: ∀ e. CircleStuff.Project -> Camera -> Renderer -> Array Number -> Eff (three :: Three | e) Unit
updateScene s c r t = do
-- Just while developing!! dangerous!
  CircleStuff.update s (unsafePartial $ unsafeIndex t 0)
-- the whole init function should be doing a lot of stuff by default
-- without us having to pass render or updatecontrol stuff
-- basically we should declare module effects and init should pick those up
-- and merge them with the default ones...
-- TODO Provide an interface to run loop with just the custom things

init :: Controls.OrbitControls -> Scene -> CircleStuff.Project -> Camera -> Renderer -> ThreeEff Unit
init controls scene project camera renderer = 
  Timeline.create calculations behaviours effects (Timeline.Frame 0)
    where 
      calculations = [incT, cosT]
      behaviours = [updateScene project camera renderer]
      effects = 
        [ Controls.updateControls controls
        , Renderer.render scene camera renderer ]

main' :: ∀ e. Eff (three :: Three, dom :: DOM, console :: CONSOLE | e) Unit
main' = do
  ar <- unsafeGetAspectRatio
  scene    <- initScene
  project  <- CircleStuff.create
  camera   <- Camera.createPerspectiveCamera 30.0 ar 1.0 10000.0
  renderer <- createRenderer
  controls <- createControls camera scene
  -- Utils
  attachAxesHelper scene 100.0
  Camera.setCameraPosition (-670.66) 875.421 (-604.84) camera
  Scene.debugScene scene
  Camera.debugCamera camera
  traverse_ (Scene.addToScene scene) (CircleStuff.exportProjectObjects project)
  Renderer.mountRenderer renderer
  -- Main loop
  -- Maybe put all this elements, scene project, camera and 
  -- renderer into a ctx that gets passed to init... or it will grow very big
  init controls scene project camera renderer

-- Pretty unsafe addEventListener...
main :: ThreeEff Unit 
main = Three.onDOMContentLoaded main' 

-- TODO:
-- 01 Make Project a graph and provide a way to traverse it
-- 02 Make results a record and provide a way to hook propery results -> Needs understading row types better
-- 03 Remove all partial unsafe functions -> needs 02
-- 04 getting 02 
-- Remove any dependency from the lib module to the three module
-- Connect datGUI to those params to get some interactivity
-- Next steps: Try to reproduce hierarchy2 example from threejs 
-- Create a set of JS utils to make IFF less painful
-- Change it on resize, updateMatrices
-- Add Camera lookAt fn
-- Create a draft of a type structure for threeJS (Object3D, Material, etc.)
-- Orbitcontrol rotate, autoupdate fns, enable zoom, etc.
-- Write a bit of documentation about the type decisions on Timeline and Main mostly
-- Remove most comments and create function names for those
-- Generalize the project file utils into a project object in Pure3
-- TODO documentReady to begin all computation, that will get proper body height values
-- onDOMcontentloaded example purescript-browser-dom/src/Browser/DOM.purs
-- Add mousePositionValues to the project update fn input
-- Move camera into project?
-- Add proper fog to scene instead of directly from js
-- Transparent canvas color?
-- Check for a way to easy the pain on wrapping unwrapping object3D
-- Move camera && calculations inside scene
-- Simplify timeline to just execute behaviours & time unbound effects
-- pass time as well as frame to behaviours...
-- get 2d coordinates from any element in canvas to match css elements on top
-- create events that snapshot time or frame and ease on the diff from initial to duration...
