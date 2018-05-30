module Projects.FrameBound.Main where

import Prelude
import Data.Int (toNumber)
import Data.Traversable (traverse_)

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)
import DOM (DOM)

import Three as Three
import Three.Camera as Camera
import Three.OrbitControls as Controls
import Three.Renderer as Renderer
import Three.Scene as Scene 
import Three.Types (Camera, Renderer, Scene, Three, ThreeEff)

import Projects.BaseProject as BaseProject
import Projects.FrameBound as FrameBound
import Timeline as Timeline

doT :: Timeline.Frame -> Number
doT n = toNumber n

initScene :: ThreeEff Scene
initScene = do 
  scene <- Scene.create
  bgColor <- Three.createColor "#A6FFD4"
  Scene.setBackground bgColor scene
  pure scene

updateScene :: ∀ e. BaseProject.Project -> Camera -> Renderer -> Timeline.Frame -> Eff (three :: Three | e) Unit
updateScene s c r t = do
  FrameBound.update s $ toNumber t

init :: Controls.OrbitControls -> Scene -> BaseProject.Project -> Camera -> Renderer -> MainEff Unit
init controls scene project camera renderer = 
  Timeline.create behaviours 0
    where 
      behaviours = 
        [ updateScene project camera renderer
        , \_ -> Controls.update controls 
        , \_ -> Renderer.render scene camera renderer ]

type MainEff a = ∀ e. Eff (three :: Three, dom :: DOM, console :: CONSOLE | e) a

main :: MainEff Unit
main = do
  ar <- BaseProject.unsafeGetAspectRatio
  scene    <- initScene
  project  <- FrameBound.create
  camera   <- Camera.create 30.0 ar 1.0 10000.0
  renderer <- BaseProject.createRenderer
  controls <- BaseProject.createControls camera scene
  -- BaseProject.attachAxesHelper scene 100.0
  Camera.setPosition (-670.66) 875.421 (-604.84) camera
  Scene.debug scene
  Camera.debug camera
  traverse_ (Scene.add scene) (BaseProject.exportProjectObjects project)
  Renderer.mount renderer
  -- Event handling
  Three.onResize $ BaseProject.handleResize camera renderer
  init controls scene project camera renderer

--- Pretty unsafe addEventListener...
--- main :: ThreeEff Unit
--- main = Three.onDOMContentLoaded main'
