module Projects.CircleStuff.Main where

import Prelude (Unit, bind, discard, negate, pure, ($), (*), (+), (/))
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Data.Int (toNumber)
import Data.Array (unsafeIndex)
import Partial.Unsafe (unsafePartial)
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..), fst, snd)
import Data.Traversable (traverse_)
import Math (cos) as Math

import DOM (DOM)
import DOM.HTML (window)
import DOM.HTML.Window (document)
import DOM.HTML.Document (body)
import DOM.HTML.HTMLElement (offsetWidth, offsetHeight) 

import Timeline (create, Frame(..)) as Timeline

import Three (createColor, createAxesHelper, onResize) as Three
import Three.Types (Camera, Renderer, Scene, Three, ThreeEff)
import Three.Scene (debug, create, setBackground, add) as Scene
import Three.Renderer (createWebGLRenderer, setPixelRatio, setSize, mount, render) as Renderer
import Three.Camera (create, debug, setPosition, setAspect, updateProjectionMatrix) as Camera
import Three.OrbitControls (OrbitControls, create, toggle, update) as Controls

import Projects.CircleStuff  as CircleStuff
import Projects.BaseProject as BaseProject

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
  scene <- Scene.create
  bgColor <- Three.createColor "#A6FFD4"
  Scene.setBackground bgColor scene
  pure scene

attachAxesHelper :: Scene -> Number -> ThreeEff Unit
attachAxesHelper scene size = do
  axesHelper <- Three.createAxesHelper size
  Scene.add scene axesHelper

createControls :: Camera -> Scene -> ThreeEff Controls.OrbitControls
createControls camera scene = do 
  controls <- Controls.create camera
  Controls.toggle false controls
  pure controls

updateScene :: ∀ e. BaseProject.Project -> Camera -> Renderer -> Array Number -> Eff (three :: Three | e) Unit
updateScene s c r t = do
-- Just while developing!! dangerous!
  CircleStuff.update s (unsafePartial $ unsafeIndex t 0)

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

handleResize :: Camera -> Renderer -> MainEff
handleResize c r = do
  ar <- unsafeGetAspectRatio
  bs <- unsafeGetBodySize
  Renderer.setSize (fst bs) (snd bs) r
  Camera.setAspect ar c
  Camera.updateProjectionMatrix c

main :: MainEff
main = do
  ar <- unsafeGetAspectRatio
  scene    <- initScene
  project  <- CircleStuff.create
  camera   <- Camera.create 30.0 ar 1.0 10000.0
  renderer <- createRenderer
  controls <- createControls camera scene
  -- attachAxesHelper scene 100.0
  Camera.setPosition (-670.66) 875.421 (-604.84) camera
  Scene.debug scene
  Camera.debug camera
  traverse_ (Scene.add scene) (BaseProject.exportProjectObjects project)
  Renderer.mount renderer
  -- Event handling
  Three.onResize $ handleResize camera renderer
  init controls scene project camera renderer

--- Pretty unsafe addEventListener...
--- main :: ThreeEff Unit
--- main = Three.onDOMContentLoaded main'
