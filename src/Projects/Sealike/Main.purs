module Projects.Sealike.Main where

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)
import DOM (DOM)
import Data.Array (unsafeIndex)
import Data.Int (toNumber)
import Data.Traversable (traverse_)
import Data.Tuple (fst, snd)
import Math (cos) as Math
import Partial.Unsafe (unsafePartial)
import Prelude (Unit, bind, discard, negate, pure, ($), (*), (+), (/))
import Projects.BaseProject as BaseProject
import Projects.Sealike as Sealike
import Three (createColor, onResize) as Three
import Three.Camera (create, debug, setPosition) as Camera
import Three.OrbitControls (OrbitControls, create, toggle, update) as Controls
import Three.Renderer (createWebGLRenderer, setPixelRatio, setSize, mount, render) as Renderer
import Three.Scene (debug, create, setBackground, add) as Scene
import Three.Types (Camera, Renderer, Scene, Three, ThreeEff)
import Timeline (create, Frame(..)) as Timeline

incT :: Timeline.Frame -> Number
incT (Timeline.Frame n) = toNumber(n + 1) / 100.0

cosT :: Timeline.Frame -> Number
cosT (Timeline.Frame n) = Math.cos(toNumber(n) * 0.01)

initScene :: ThreeEff Scene
initScene = do 
  scene <- Scene.create
  bgColor <- Three.createColor "#000000"
  Scene.setBackground bgColor scene
  pure scene

updateScene :: ∀ e. BaseProject.Project -> Camera -> Renderer -> Array Number -> Eff (three :: Three | e) Unit
updateScene s c r t = do
-- Just while developing!! dangerous!
  Sealike.update s (unsafePartial $ unsafeIndex t 0)

init :: Controls.OrbitControls -> Scene -> BaseProject.Project -> Camera -> Renderer -> ThreeEff Unit
init controls scene project camera renderer = 
  Timeline.create calculations behaviours effects (Timeline.Frame 0)
    where 
      calculations = [incT, cosT]
      behaviours = [updateScene project camera renderer]
      effects = 
        [ Controls.update controls
        , Renderer.render scene camera renderer ]

type MainEff = ∀ e. Eff (three :: Three, dom :: DOM, console :: CONSOLE | e) Unit

main :: MainEff
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
  Three.onResize $ BaseProject.handleResize camera renderer  
  init controls scene project camera renderer
