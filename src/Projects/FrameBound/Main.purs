module Projects.FrameBound.Main where

import Prelude

import Effect
import Effect.Class.Console as Console

import Data.Int (toNumber)
import Data.Traversable (traverse_)
import Projects.BaseProject as BaseProject
import Projects.FrameBound as FrameBound
import Three as Three
import Three.Camera as Camera
import Three.OrbitControls as Controls
import Three.Renderer as Renderer
import Three.Scene as Scene
import Three.Types (Camera, Renderer, Scene)
import Timeline as Timeline

doT :: Timeline.Frame -> Number
doT n = toNumber n

backgroundColor = "#e3e0db"

initScene :: Effect Scene
initScene = do 
  scene <- Scene.create
  bgColor <- Three.createColor backgroundColor
  Scene.setBackground bgColor scene
  pure scene

updateScene :: ∀ e. BaseProject.Project -> Camera -> Renderer -> Timeline.Frame -> Effect  Unit
updateScene s c r t = do
  FrameBound.update s $ toNumber t

init :: Controls.OrbitControls -> Scene -> BaseProject.Project -> Camera -> Renderer -> Effect  Unit
init controls scene project camera renderer = 
  Timeline.create behaviours 0
    where 
      behaviours = 
        [ updateScene project camera renderer
        , \_ -> Controls.update controls 
        , \_ -> Renderer.render scene camera renderer ]

main :: Effect Unit
main = do
  ar <- BaseProject.unsafeGetAspectRatio
  scene    <- initScene
  project  <- FrameBound.create
  camera   <- Camera.create 30.0 ar 1.0 1000000.0
  -- Renderer
  renderer <- BaseProject.createRenderer
  _ <- Renderer.setShadowMap true renderer
  -- EO Renderer
  controls <- BaseProject.createControls camera scene
  -- Controls.setAutoRotate true controls
  BaseProject.attachAxesHelper scene 10000.0
  -- Camera.lookAt 1000.0 0.0 1000.0 camera
  Camera.setPosition (-2773.91) 8905.60 (-10409.96) camera
  Scene.debug scene
  Camera.debug camera
  traverse_ (Scene.add scene) (BaseProject.exportProjectObjects project)
  Renderer.mount renderer
  -- Event handling
  -- Three.onResize $ BaseProject.handleResize camera renderer
  init controls scene project camera renderer

--- Pretty unsafe addEventListener...
--- main :: Effect Unit
--- main = Three.onDOMContentLoaded main'
