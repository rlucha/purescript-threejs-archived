module Projects.CircleStuff
  (create, update)
where

import Prelude
import Effect
import Data.Array as Array
import Data.Int as Int
import Data.List (List, (..))
import Data.List as List
import Data.Traversable as Traversable
import Math as Math

import Pure3.Types (Circle, Point(..))
import Pure3.Circle as Circle
import Pure3.Point as Point
import Pure3.Interpolate as Interpolate

import Three as Three
import Three.Types (Object3D)
import Three.Geometry.BoxGeometry as BoxGeometry
import Three.Materials.MeshPhongMaterial as MeshPhongMaterial
import Three.Object3D as Object3D
import Three.Object3D.Light.AmbientLight as AmbientLight
import Three.Object3D.Light.DirectionalLight as DirectionalLight
import Three.Object3D.Mesh as Object3D.Mesh 

import Projects.BaseProject (Project)
import Projects.BaseProject as BaseProject

radius = 200.0
steps = 80
amplitude = 0.000025
speed = 0.02
distance = 75.0
elements = 8
size = 8.0
boxColor = "#FFD9DC"
directionalColor = "#ff0000"
ambientColor = "#44d9e6"

centers :: List Point
centers = Point.create 0.0 0.0 <<< (*) distance <<< Int.toNumber <$> -elements..elements

circles :: List Circle
circles = flip Circle.create radius <$> centers

points :: List Point
points = List.concat $ Interpolate.interpolate steps <$> circles

updateBox :: Number -> Point -> Object3D -> Effect Unit
updateBox t (Point {x,y,z}) o = do
  let tLoop = Math.cos(t * speed)
      -- offset = Math.cos(t * speed)
      -- Initital position + Loop * modifier
      -- Try to get the inverse of pow z z or another fn that makes the center of the scene more interesting...
      waveOutX = x + ((x * tLoop) * ((z * z * amplitude)))
      waveOutY = y + ((y * tLoop) * ((z * z * amplitude)))
      rot = (x + y + z) * 0.01 + (t * speed)
  Object3D.setPosition waveOutX waveOutY z o
  -- Ideas, set rotation to one/two axis only
  Object3D.setRotation rot rot rot o

update :: Project -> Number -> Effect Unit
update p t = 
  Traversable.sequence_ $ Array.zipWith (updateBox t) (Array.fromFoldable points) (BaseProject.getProjectObjects p) 

createBoxes :: List Point -> Effect (Array Object3D)
createBoxes ps = do
  boxColor <- Three.createColor boxColor
  boxMat <- MeshPhongMaterial.create boxColor true
  boxGs <- Traversable.traverse (\_ -> BoxGeometry.create 20.0 80.0 20.0) ps
  boxMeshes <- Traversable.traverse (flip Object3D.Mesh.create boxMat) boxGs
  -- _ <- sequence_ $ zipWith setPositionByPoint points boxMeshes
  pure $ Array.fromFoldable boxMeshes

setPositionByPoint :: Point -> Object3D -> Effect Unit
-- Maybe make Object3D.setPosition accept a Point || Vector3 so we can avoid unwrapping points here?
setPositionByPoint (Point {x, y, z}) o = Object3D.setPosition x y z o

create :: Effect Project
create = do
  boxes <- createBoxes points
  dColor <- Three.createColor directionalColor
  dlight <-  DirectionalLight.create dColor 1.0
  aColor <- Three.createColor ambientColor
  alight <- AmbientLight.create aColor 0.75
  pure $ BaseProject.Project { objects: Array.concat [boxes <> [dlight, alight]], vectors: [] }
