module Projects.Sealike.Main where

import Prelude
import Effect
import Effect.Class.Console as Console
import Data.Int (toNumber)
import Data.Traversable (traverse_)

import Three as Three
import Three.Camera as Camera
import Three.OrbitControls as Controls
import Three.Renderer as Renderer
import Three.Scene as Scene 
import Three.Types (Camera, Renderer, Scene)
import Timeline as Timeline

import Projects.BaseProject as BaseProject
import Projects.Sealike as Sealike

initScene :: Effect Scene
initScene = do 
  scene <- Scene.create
  bgColor <- Three.createColor "#000000"
  Scene.setBackground bgColor scene
  pure scene

updateScene :: BaseProject.Project -> Camera -> Renderer -> Timeline.Frame -> Effect Unit
updateScene s c r t = do
  Sealike.update s $ toNumber t

init :: Controls.OrbitControls -> Scene -> BaseProject.Project -> Camera -> Renderer -> Effect Unit
init controls scene project camera renderer = 
  Timeline.create behaviours 0
    where 
      behaviours = 
        [ updateScene project camera renderer
        , \_ -> Controls.update controls 
        , \_ -> Renderer.render scene camera renderer ]

main :: Effect  Unit
main = do
  ar <- BaseProject.unsafeGetAspectRatio
  scene    <- initScene
  project  <- Sealike.create
  camera   <- Camera.create 30.0 ar 1.0 10000.0
  renderer <- BaseProject.createRenderer
  controls <- BaseProject.createControls camera scene
  -- BaseProject.attachAxesHelper scene 100.0
  Camera.setPosition (-1215.27) 285.24 (153.98) camera
  Scene.debug scene
  Camera.debug camera
  traverse_ (Scene.add scene) (BaseProject.exportProjectObjects project)
  Renderer.mount renderer
  -- Event handling
  -- Three.onResize $ BaseProject.handleResize camera renderer
  init controls scene project camera renderer
