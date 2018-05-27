module Projects.FrameBound
  (create, update)
where

import Data.Array (fromFoldable, concat) as Array
import Data.Int (toNumber)
import Data.List (List, (..), concat, zipWith)
import Data.Traversable (traverse, traverse_, sequence_)
import Math (cos) as Math
import Prelude (Unit, bind, discard, flip, negate, pure, ($), (*), (+), (<$>), (<<<), (<>), (=<<))
import Projects.BaseProject (Project(Project), getProjectObjects) as BaseProject
import Pure3.Circle as C
import Pure3.Interpolate as Interpolate
import Pure3.Point as P
import Three (createColor)
import Three.Geometry.BoxGeometry (create) as BoxGeometry
import Three.Materials.MeshPhongMaterial (create) as MeshPhongMaterial
import Three.Object3D (getPosition, setPosition, setRotation) as Object3D
import Three.Object3D.Light.AmbientLight (create) as AmbientLight
import Three.Object3D.Light.DirectionalLight (create) as DirectionalLight
import Three.Object3D.Mesh (create) as Object3D.Mesh
import Three.Types (Object3D, ThreeEff)

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

centers :: List P.Point
centers = P.create 0.0 0.0 <<< (*) distance <<< toNumber <$> -elements..elements

circles :: List C.Circle
circles = flip C.create radius <$> centers

points :: List P.Point
points = concat $ Interpolate.interpolate steps <$> circles

updateBox :: Number -> Object3D -> ThreeEff Unit
updateBox t o = do
  posV3 <- Object3D.getPosition o
  let x = Math.cos(t * 0.1) * amplitude
      y = Math.cos(t * 0.1) * amplitude
      z = Math.cos(t * 0.1) * amplitude
  Object3D.setPosition x y z o

update :: BaseProject.Project -> Number -> ThreeEff Unit
update p t = traverse_ (updateBox t) (BaseProject.getProjectObjects p) 

createBoxes :: List P.Point -> ThreeEff (Array Object3D)
createBoxes ps = do
  bgColor <- createColor bgColor
  boxMat <- MeshPhongMaterial.create bgColor true
  boxGs <- traverse (\_ -> BoxGeometry.create 20.0 80.0 20.0) ps
  boxMeshes <- traverse (flip Object3D.Mesh.create boxMat) boxGs
  _ <- sequence_ $ zipWith setPositionByPoint points boxMeshes
  pure $ Array.fromFoldable boxMeshes

setPositionByPoint :: P.Point -> Object3D -> ThreeEff Unit
-- Maybe make Object3D.setPosition accept a Point || Vector3 so we can avoid unwrapping points here?
setPositionByPoint (P.Point {x, y, z}) o = Object3D.setPosition x y z o

create :: ThreeEff BaseProject.Project
create = do
  boxes <- createBoxes points
  dlight <-  DirectionalLight.create =<< createColor directionalColor
  alight <- AmbientLight.create =<< createColor ambientColor
  pure $ BaseProject.Project { objects: Array.concat [boxes <> [dlight, alight]], vectors: [] }
