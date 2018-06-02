module Projects.CircleStuff.Main where

import Prelude 
import Data.Int as Int
import Data.Traversable as Traversable
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)
import DOM (DOM)

import Three as Three
import Three.Types (Camera, Renderer, Scene, THREE, ThreeEff)
import Three.Camera as Camera
import Three.OrbitControls as Controls
import Three.Renderer as Renderer
import Three.Scene as Scene 
import Timeline as Timeline

import Projects.BaseProject as BaseProject
import Projects.CircleStuff as CircleStuff

initScene :: ThreeEff Scene
initScene = do 
  scene <- Scene.create
  bgColor <- Three.createColor "#A6FFD4"
  Scene.setBackground bgColor scene
  Scene.debug scene
  pure scene

updateScene :: ∀ e. BaseProject.Project -> Camera -> Renderer -> Timeline.Frame -> Eff (three :: THREE | e) Unit
updateScene s c r t = do
  CircleStuff.update s $ Int.toNumber t

init :: Controls.OrbitControls -> Scene -> BaseProject.Project -> Camera -> Renderer -> MainEff Unit
init controls scene project camera renderer = 
  Timeline.create behaviours 0
    where 
      behaviours = 
        [ updateScene project camera renderer
        -- , \_ -> Controls.update controls 
        , \_ -> Renderer.render scene camera renderer ]

type MainEff a = ∀ e. Eff (three :: THREE, dom :: DOM, console :: CONSOLE | e) a

initCamera :: MainEff Camera
initCamera = do
  -- Camera.lookAt doesn't work with controls enabled...
  ar       <- BaseProject.unsafeGetAspectRatio
  camera   <- Camera.create 30.0 ar 1.0 10000.0
  Camera.setPosition (-571.77) 1856.65 (-799.26) camera
  Camera.lookAt 0.0 0.0 0.0 camera 
  Camera.debug camera
  pure camera

main :: MainEff Unit
main = do
  scene    <- initScene
  camera   <- initCamera
  project  <- CircleStuff.create
  renderer <- BaseProject.createRenderer
  controls <- BaseProject.createControls camera scene
  -- BaseProject.attachAxesHelper scene 1000.0
  -- This might be an effect on timeline
  -- If we pass a frame to scene, we can make it add elements to the scene only 
  -- if within the frame constrains
  Traversable.traverse_ (Scene.add scene) (BaseProject.exportProjectObjects project)
  Renderer.mount renderer
  -- Event handling
  Three.onResize $ BaseProject.handleResize camera renderer
  init controls scene project camera renderer

--- Pretty unsafe addEventListener...
--- main :: ThreeEff Unit
--- main = Three.onDOMContentLoaded main'
