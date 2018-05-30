module Projects.FrameBound
  (create, update)
where

import Data.Array as Array
import Data.Int (toNumber)
import Data.List (List(..), (..))
import Data.List as List
import Data.Traversable (traverse, traverse_, sequence_)
import Math as Math
import Prelude
import Pure3.Circle (Circle(..))
import Pure3.Circle as Circle
import Pure3.Point (Point(..))
import Pure3.Point as Point
import Pure3.Interpolate as Interpolate

import Three as Three
import Three.Geometry.BoxGeometry as BoxGeometry
import Three.Materials.MeshPhongMaterial as MeshPhongMaterial
import Three.Object3D as Object3D
import Three.Object3D.Light.AmbientLight as AmbientLight
import Three.Object3D.Light.DirectionalLight as DirectionalLight
import Three.Object3D.Mesh as Object3D.Mesh
import Three.Types (Object3D, ThreeEff)

import Projects.BaseProject (Project(..))
import Projects.BaseProject as BaseProject


radius = 200.0
steps = 50
amplitude = 50.0
speed = 1.0
distance = 50.0
elements = 10
size = 8.0
bgColor = "#339966"
directionalColor = "#ff0000"
ambientColor = "#44d9e6"

centers :: List Point
centers = Point.create 0.0 0.0 <<< (*) distance <<< toNumber <$> -elements..elements

circles :: List Circle
circles = flip Circle.create radius <$> centers

points :: List Point
points = List.concat $ Interpolate.interpolate steps <$> circles

updateBox :: Number -> Object3D -> ThreeEff Unit
updateBox t o = do
  posV3 <- Object3D.getPosition o
  let x = Math.cos(t * 0.1) * amplitude
      y = Math.cos(t * 0.1) * amplitude
      z = Math.cos(t * 0.1) * amplitude
  Object3D.setPosition x y z o

update :: BaseProject.Project -> Number -> ThreeEff Unit
update p t = traverse_ (updateBox t) (BaseProject.getProjectObjects p) 

createBoxes :: List Point -> ThreeEff (Array Object3D)
createBoxes ps = do
  bgColor <- Three.createColor bgColor
  boxMat <- MeshPhongMaterial.create bgColor true
  boxGs <- traverse (\_ -> BoxGeometry.create 20.0 80.0 20.0) ps
  boxMeshes <- traverse (flip Object3D.Mesh.create boxMat) boxGs
  _ <- sequence_ $ List.zipWith setPositionByPoint points boxMeshes
  pure $ Array.fromFoldable boxMeshes

setPositionByPoint :: Point -> Object3D -> ThreeEff Unit
-- Maybe make Object3D.setPosition accept a Point || Vector3 so we can avoid unwrapping points here?
setPositionByPoint (Point {x, y, z}) o = Object3D.setPosition x y z o

create :: ThreeEff BaseProject.Project
create = do
  boxes <- createBoxes points
  dlight <-  DirectionalLight.create =<< Three.createColor directionalColor
  aColor <- Three.createColor ambientColor
  alight <- AmbientLight.create aColor 0.75
  pure $ BaseProject.Project { objects: Array.concat [boxes <> [dlight, alight]], vectors: [] }
