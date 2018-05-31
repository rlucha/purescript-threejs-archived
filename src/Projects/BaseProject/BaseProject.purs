module Projects.BaseProject where

import Prelude (Unit, bind, discard, pure, ($), (/), (<$>))

import DOM (DOM)
import DOM.HTML (window)
import DOM.HTML.Document (body)
import DOM.HTML.HTMLElement (offsetHeight, offsetWidth)
import DOM.HTML.Window (document)
import Control.Monad.Eff (Eff)
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..), fst, snd)
import Pure3.Types (Point(..))

import Three as Three
import Three.Types (Camera, Object3D, Object3D_, Renderer, Scene, Three, ThreeEff, Vector3)
import Three.Camera as Camera
import Three.Object3D as Object3D
import Three.OrbitControls as Controls
import Three.Renderer as Renderer
import Three.Scene as Scene

newtype Project = Project
  { objects :: Array Object3D
  , vectors :: Array Vector3 }

getProjectObjects :: Project -> Array Object3D
getProjectObjects (Project r) = r.objects

getProjectVectors :: Project -> Array Vector3
getProjectVectors (Project r) = r.vectors

exportProjectObjects :: Project -> Array Object3D_
exportProjectObjects (Project r) = Object3D.unwrap <$> r.objects

createVectorFromPoint :: Point -> ThreeEff Vector3
createVectorFromPoint (Point {x, y, z}) = Three.createVector3 x y z

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

handleResize :: Camera -> Renderer -> ∀ e. Eff (three :: Three, dom :: DOM | e) Unit
handleResize c r = do
  ar <- unsafeGetAspectRatio
  bs <- unsafeGetBodySize
  Renderer.setSize (fst bs) (snd bs) r
  Camera.setAspect ar c
  Camera.updateProjectionMatrix c

attachAxesHelper :: Scene -> Number -> ThreeEff Unit
attachAxesHelper scene size = do
  axesHelper <- Three.createAxesHelper size
  Scene.add scene axesHelper

createRenderer :: ∀ e. Eff (three :: Three, dom :: DOM | e) Renderer
createRenderer = do 
  bs <- unsafeGetBodySize
  r <- Renderer.createWebGLRenderer
  Renderer.setPixelRatio r
  Renderer.setSize (fst bs) (snd bs) r
  pure r

createControls :: Camera -> Scene -> ThreeEff Controls.OrbitControls
createControls camera scene = do 
  controls <- Controls.create camera
  Controls.toggle false controls
  pure controls
