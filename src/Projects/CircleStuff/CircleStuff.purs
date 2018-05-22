module Projects.CircleStuff
  (create, update)
where

import Prelude (Unit, bind, discard, negate, pure, ($), (*), (*>), (+), (/), (<$>), (<<<), (<>))
import Data.Int (toNumber)
import Data.List (List, (..), concat, zipWith)
import Data.Array (fromFoldable, concat) as Array
import Data.Traversable (traverse, traverse_, sequence_)
import Math (cos) as Math

import Pure3.Point as P
import Pure3.Circle as C
import Pure3.Interpolate as Interpolate

import Three (createColor, createVector3, createGeometry, getVector3Position, pushVertices, updateVector3Position)
import Three.Geometry.BoxGeometry (create) as BoxGeometry
import Three.Types (Object3D, ThreeEff, Vector3)
import Three.Object3D (forceVerticesUpdate, getPosition, setPosition, setRotation) as Object3D
import Three.Object3D.Points (create) as Object3D.Points
import Three.Object3D.Mesh (create) as Object3D.Mesh
import Three.Materials.MeshPhongMaterial (create) as MeshPhongMaterial
import Three.Object3D.Light.DirectionalLight (create) as DirectionalLight
import Three.Object3D.Light.AmbientLight (create) as AmbientLight

import Projects.Sealike.SeaMaterial (createSeaMaterial)
import Projects.BaseProject (Project(..), getProjectObjects, getProjectVectors, createVectorFromPoint) as BaseProject

radius :: Number
radius = 200.0
steps :: Int
steps = 50
amplitude :: Number
amplitude = 1.0
speed :: Number
speed = 1.0
distance :: Number
distance = 50.0
elements :: Int
elements = 10
size = 8.0

centers :: List P.Point
centers = (\n -> P.create 0.0 0.0 (n * distance)) <<< toNumber <$> -elements..elements

-- aoid using a lambda here using applicative? problem is radius is not in a context
circles :: List C.Circle
circles = (\c -> C.create c radius) <$> centers

circle :: C.Circle
circle = C.create (P.create 0.0 0.0 0.0) radius

sq1Points :: List P.Point
sq1Points = concat $ (\c -> Interpolate.interpolate c steps) <$> circles

updateVector :: Number -> Vector3 -> ThreeEff Unit
updateVector t v = do
  vpos <- getVector3Position v
  -- we need some initial position to use it as a reference point for
  -- incremental changes
  -- reader monad here?
  let delta = (vpos.x / vpos.y)
              -- 0pos    + pos dependant cos over time and amplitude
      waveOutX = (vpos.x + ((vpos.x * (Math.cos (t * speed))) * amplitude) * vpos.z / 10.0)
      waveOutY = (vpos.y + ((vpos.y * (Math.cos (t * speed))) * amplitude) * vpos.z / 10.0)
  updateVector3Position waveOutX waveOutY vpos.z v

updateBox :: Number -> Object3D -> ThreeEff Unit
updateBox t o = do
  posV3 <- Object3D.getPosition o
  let waveOutX = posV3.x + ((posV3.x * Math.cos(t * speed)) * (posV3.z) * 0.00025)
      waveOutY = posV3.y + ((posV3.y * Math.cos(t * speed)) * (posV3.z) * 0.00025)
      rotY = (posV3.y * 0.01 + t)
  Object3D.setPosition waveOutX waveOutY posV3.z o
  Object3D.setRotation rotY rotY rotY o

updateBoxes :: BaseProject.Project -> Number -> ThreeEff Unit
updateBoxes p t = 
  let obs = BaseProject.getProjectObjects p
    in traverse_ (updateBox t) obs 

updatePoints :: BaseProject.Project -> Number -> ThreeEff Unit
updatePoints p t =
  let vs  = BaseProject.getProjectVectors p
      g   = BaseProject.getProjectObjects p
  in traverse_ (updateVector t) vs *> (sequence_ $ Object3D.forceVerticesUpdate <$> g)

update :: BaseProject.Project -> Number -> ThreeEff Unit
update = updateBoxes

createBoxes :: List P.Point -> ThreeEff (Array Object3D)
createBoxes ps = do
  bgColor <- createColor "#339966"
  boxMat <- MeshPhongMaterial.create bgColor true
  boxGs <- traverse (\_ -> BoxGeometry.create 20.0 80.0 20.0) ps
  boxMeshes <- traverse (\g -> Object3D.Mesh.create g boxMat) boxGs
  _ <- sequence_ $ zipWith setPositionByPoint sq1Points boxMeshes
  pure $ Array.fromFoldable boxMeshes

setPositionByPoint :: P.Point -> Object3D -> ThreeEff Unit
setPositionByPoint p o = 
  let {x, y, z} = P.unwrap p
  in Object3D.setPosition x y z o

create :: ThreeEff BaseProject.Project
create = do
  boxes <- createBoxes sq1Points
  lightColor1 <- createColor "#ff0000"
  lightColor2 <- createColor "#44d9e6"
  dlight <- DirectionalLight.create lightColor1
  alight <- AmbientLight.create lightColor2
  pure $ BaseProject.Project { objects: Array.concat [boxes <> [dlight, alight]], vectors: [] }
