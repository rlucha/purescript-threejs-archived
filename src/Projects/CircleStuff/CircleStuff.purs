module Projects.CircleStuff
  (create, update)
where

import Prelude (Unit, bind, discard, negate, pure, ($), (*), (+), (<$>), (<<<), (<>), flip)
import Data.Int (toNumber)
import Data.List (List, (..), concat, zipWith)
import Data.Array (fromFoldable, concat) as Array
import Data.Traversable (traverse, traverse_, sequence_)
import Math (cos) as Math

import Pure3.Point as P
import Pure3.Circle as C
import Pure3.Interpolate as Interpolate

import Three (createColor)
import Three.Geometry.BoxGeometry (create) as BoxGeometry
import Three.Types (Object3D, ThreeEff)
import Three.Object3D (getPosition, setPosition, setRotation) as Object3D
import Three.Object3D.Mesh (create) as Object3D.Mesh
import Three.Materials.MeshPhongMaterial (create) as MeshPhongMaterial
import Three.Object3D.Light.DirectionalLight (create) as DirectionalLight
import Three.Object3D.Light.AmbientLight (create) as AmbientLight

import Projects.BaseProject (Project(Project), getProjectObjects) as BaseProject

radius = 200.0
steps = 50
amplitude = 1.0
speed = 1.0
distance = 50.0
elements = 10
size = 8.0

centers :: List P.Point
centers = P.create 0.0 0.0 <<< (*) distance <<< toNumber <$> -elements..elements

circles :: List C.Circle
circles = flip C.create radius <$> centers

points :: List P.Point
points = concat $ Interpolate.interpolate steps <$> circles

updateBox :: Number -> Object3D -> ThreeEff Unit
updateBox t o = do
  posV3 <- Object3D.getPosition o
  let waveOutX = posV3.x + ((posV3.x * Math.cos(t * speed)) * (posV3.z) * 0.00025)
      waveOutY = posV3.y + ((posV3.y * Math.cos(t * speed)) * (posV3.z) * 0.00025)
      rotY = (posV3.y * 0.01 + t)
  Object3D.setPosition waveOutX waveOutY posV3.z o
  Object3D.setRotation rotY rotY rotY o

update :: BaseProject.Project -> Number -> ThreeEff Unit
update p t = 
  let obs = BaseProject.getProjectObjects p
    in traverse_ (updateBox t) obs 

createBoxes :: List P.Point -> ThreeEff (Array Object3D)
createBoxes ps = do
  bgColor <- createColor "#339966"
  boxMat <- MeshPhongMaterial.create bgColor true
  boxGs <- traverse (\_ -> BoxGeometry.create 20.0 80.0 20.0) ps
  boxMeshes <- traverse (\g -> Object3D.Mesh.create g boxMat) boxGs
  _ <- sequence_ $ zipWith setPositionByPoint points boxMeshes
  pure $ Array.fromFoldable boxMeshes

setPositionByPoint :: P.Point -> Object3D -> ThreeEff Unit
setPositionByPoint p o = 
  let {x, y, z} = P.unwrap p
  in Object3D.setPosition x y z o

create :: ThreeEff BaseProject.Project
create = do
  boxes <- createBoxes points
  lightColor1 <- createColor "#ff0000"
  lightColor2 <- createColor "#44d9e6"
  dlight <- DirectionalLight.create lightColor1
  alight <- AmbientLight.create lightColor2
  pure $ BaseProject.Project { objects: Array.concat [boxes <> [dlight, alight]], vectors: [] }
