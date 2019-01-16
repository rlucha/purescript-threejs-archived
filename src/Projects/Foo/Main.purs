module Projects.Foo.Main where

import Prelude 
import Data.Int as Int
import Data.Traversable as Traversable
import Effect

import Three as Three
import Three.Types (Camera, Renderer, Scene)
import Three.Camera as Camera
import Three.OrbitControls as Controls
import Three.Renderer as Renderer
import Three.Scene as Scene 
import Timeline as Timeline

import Projects.BaseProject as BaseProject
import Projects.Foo as Foo

initScene :: Effect Scene
initScene = do 
  scene <- Scene.create
  bgColor <- Three.createColor "#204066"
  Scene.setBackground bgColor scene
  Scene.debug scene
  pure scene

updateScene :: ∀ e. BaseProject.Project -> Camera -> Renderer -> Timeline.Frame -> Effect  Unit
updateScene s c r t = do
  Foo.update s $ Int.toNumber t

init :: Controls.OrbitControls -> Scene -> BaseProject.Project -> Camera -> Renderer -> Effect  Unit
init controls scene project camera renderer = 
  Timeline.create behaviours 0
    where 
      behaviours = 
        [ updateScene project camera renderer
        -- , \_ -> Controls.update controls 
        , \_ -> Renderer.render scene camera renderer ]

initCamera :: Effect Camera
initCamera = do
  -- Camera.lookAt doesn't work with controls enabled...
  ar       <- BaseProject.unsafeGetAspectRatio
  camera   <- Camera.create 30.0 ar 1.0 10000.0
  Camera.setPosition 0.0 0.0 (-800.00) camera
  Camera.lookAt 0.0 0.0 0.0 camera 
  Camera.debug camera
  pure camera

main :: Effect Unit
main = do
-- TODO we can move all this initializatio (camera, scene, renderer to a common file)
  scene    <- initScene
  camera   <- initCamera
  project  <- Foo.create
  renderer <- BaseProject.createRenderer
  controls <- BaseProject.createControls camera scene
  -- BaseProject.attachAxesHelper scene 1000.0
  -- This might be an effect on timeline
  -- If we pass a frame to scene, we can make it add elements to the scene only 
  -- if within the frame constrains
  Traversable.traverse_ (Scene.add scene) (BaseProject.exportProjectObjects project)
  Renderer.mount renderer
  -- Event handling
  -- Three.onResize $ BaseProject.handleResize camera renderer
  init controls scene project camera renderer

--- Pretty unsafe addEventListener...
--- main :: Effect Unit
--- main = Three.onDOMContentLoaded main'
