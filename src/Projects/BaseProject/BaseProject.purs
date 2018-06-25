module Projects.BaseProject where

import Prelude (Unit, bind, discard, pure, ($), (/), (<$>))

import Web.HTML (window)
import Web.HTML.Window (document)

import Web.HTML.HTMLDocument (body)
import Web.HTML.HTMLElement (offsetHeight, offsetWidth)

import Effect
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..), fst, snd)
import Pure3.Types (Point(..))

import Three as Three
import Three.Types (Camera, Object3D, Object3D_, Renderer, Scene, Vector2, Vector3)
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

createVector3FromPoint :: Point -> Effect Vector3
createVector3FromPoint (Point {x, y, z}) = Three.createVector3 x y z

createVector2FromPoint :: Point -> Effect Vector2
createVector2FromPoint (Point {x, y}) = Three.createVector2 x y

unsafeGetAspectRatio :: Effect  Number
unsafeGetAspectRatio = do
  bs <- unsafeGetBodySize
  pure ((fst bs) / (snd bs))

unsafeGetBodySize :: Effect  (Tuple Number Number)
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

handleResize :: Camera -> Renderer -> Effect  Unit
handleResize c r = do
  ar <- unsafeGetAspectRatio
  bs <- unsafeGetBodySize
  Renderer.setSize (fst bs) (snd bs) r
  Camera.setAspect ar c
  Camera.updateProjectionMatrix c

attachAxesHelper :: Scene -> Number -> Effect Unit
attachAxesHelper scene size = do
  axesHelper <- Three.createAxesHelper size
  Scene.add scene axesHelper

createRenderer :: Effect  Renderer
createRenderer = do 
  bs <- unsafeGetBodySize
  r <- Renderer.createWebGLRenderer
  Renderer.setPixelRatio r
  Renderer.setSize (fst bs) (snd bs) r
  pure r

createControls :: Camera -> Scene -> Effect  Controls.OrbitControls
createControls camera scene = do 
  controls <- Controls.create camera
  Controls.toggle true controls
  pure controls
