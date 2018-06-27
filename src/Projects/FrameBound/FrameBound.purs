module Projects.FrameBound where

import Data.Either
import Data.List.Types
import Effect
import Prelude
import Projects.FrameBound.Types

import Control.Extend ((<<=))
import Control.Monad.Except (runExcept)
import Data.Array as Array
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.List (List, (..), zipWith, (:))
import Data.List as List
import Data.Maybe (fromMaybe)
import Data.Newtype (class Newtype, unwrap)
import Data.Traversable (maximum, sequence_, traverse, traverse_)
import Effect.Class.Console as Console
import Foreign (ForeignError(..))
import Foreign.Class (class Decode, class Encode)
import Foreign.Generic (decodeJSON, defaultOptions, genericDecode, genericDecodeJSON, genericEncode)
import Math as Math
import Projects.BaseProject (Project)
import Projects.BaseProject as BaseProject
import Projects.FrameBound.MapLoader as MapLoader
import Projects.FrameBound.Projection as Projection
import Pure3.Point (Point(..))
import Pure3.Point as Point
import Three as Three
import Three.Extras.Core.Shape as Shape
import Three.Geometry.BoxGeometry as BoxGeometry
import Three.Geometry.ExtrudeGeometry as ExtrudeGeometry
import Three.Geometry.PlaneGeometry as PlaneGeometry
import Three.Materials.MeshPhongMaterial as MeshPhongMaterial
import Three.Materials.LineBasicMaterial as LineBasicMaterial
import Three.Math as ThreeMath
import Three.Object3D (setPosition)
import Three.Object3D as Object3D
import Three.Object3D.Light.AmbientLight as AmbientLight
import Three.Object3D.Light.DirectionalLight as DirectionalLight
import Three.Object3D.Light.HemisphereLight as HemisphereLight
import Three.Object3D.Mesh as Object3D.Mesh
import Three.Object3D.Line as Object3D.Line
import Three.Types (Object3D, Vector2)

scale = 3.0
elements = 50
area = 500.0
boxColor = "#FCCA46"
directionalColor = "#ffffff"
dIntensity = 0.3
skyColor = "#ffffff"
groundColor = "#999999"
floorColor = "#A1C181"

update :: Project -> Number -> Effect  Unit
update p t = pure unit

setPositionByPoint :: Point -> Object3D -> Effect  Unit
-- Maybe make Object3D.setPosition accept a Point || Vector3 so we can avoid unwrapping points here?
setPositionByPoint (Point {x, y, z}) o = Object3D.setPosition x y z o

buildingToMesh :: Array Point -> Effect Object3D
buildingToMesh ps = do 
  boxColor <- Three.createColor boxColor
  vs <- traverse (projectBuildingPoint scale) ps
  sh <- Shape.create vs
  -- Pass estrusion from config, eventually use LIDAR
  ex <- ExtrudeGeometry.create 2.0 sh 
  mat <- MeshPhongMaterial.create boxColor true
  o3d <- Object3D.Mesh.create ex mat
  _ <- Object3D.setReceiveShadow true o3d
  _ <- Object3D.setCastShadow true o3d
  pure o3d 

streetToLine :: Array Point -> Effect Object3D
streetToLine ps = do 
  boxColor <- Three.createColor boxColor
  vs <- traverse (projectBuildingPoint scale) ps
  sh <- Shape.create vs
  -- Pass estrusion from config, eventually use LIDAR
  ex <- ExtrudeGeometry.create 2.0 sh 
  mat <- LineBasicMaterial.create boxColor
  o3d <- Object3D.Line.create ex mat
  _ <- Object3D.setReceiveShadow true o3d
  _ <- Object3D.setCastShadow true o3d
  pure o3d 


-- project to desired scale
-- get example working in the js only playground and reproduce here
-- Using 3d points, we do not need to do most of this stuff and just project those into the view
projectBuildingPoint :: Number -> Point -> Effect  Vector2
projectBuildingPoint sc (Point {x, y, z}) = 
  Three.createVector2 x' z'
  where x' = x * sc
        z' = z * sc

buildingCoordsToPoints :: Building -> Array Point
buildingCoordsToPoints (Building b) = 
  (\(Coords {x, y, z}) -> Point.create x y z) <$> _.coordinates b

streetCoordsToPoints :: Street -> Array Point
streetCoordsToPoints (Street s) = 
  (\(Coords {x, y, z}) -> Point.create x y z) <$> _.coordinates s

-- Maybe use a general function instead of a named one?
translateToCenter :: Point -> Array Point -> Array Point
translateToCenter center ps = (-) center <$> ps

createBuildings :: Array Building -> Point -> Effect  (Array Object3D)
createBuildings bs center = do
  let ps = translateToCenter center <<< buildingCoordsToPoints <$> bs
  boxMeshes <- traverse buildingToMesh ps
  -- Do proper numbers here instead of magic
  sequence_ $ Object3D.setRotation (-90.0 * (Math.pi / 180.0)) 0.0 0.0 <$> boxMeshes
  pure $ Array.fromFoldable boxMeshes

createLines :: Array Street -> Point -> Effect  (Array Object3D)
createLines sts center = do
  let ps = translateToCenter center <<< streetCoordsToPoints <$> sts
  lineMeshes <- traverse streetToLine ps
  -- Do proper numbers here instead of magic
  sequence_ $ Object3D.setRotation (-90.0 * (Math.pi / 180.0)) 0.0 0.0 <$> lineMeshes
  pure $ Array.fromFoldable lineMeshes

createPlane :: Effect Object3D
createPlane = do
-- There is a pattner of doing this over and over again
-- create a color, a geometry, a material, and then a mesh of all that
-- maybe we should create a more abstract function for this
-- like createMesh(MeshConfig)
  c <- Three.createColor floorColor
  g <- PlaneGeometry.create 25000.0 25000.0 1 1
  m <- MeshPhongMaterial.create c true
  p <- Object3D.Mesh.create g m
  _ <- Object3D.setReceiveShadow true p
  rx <- ThreeMath.degToRad(-90.0)
  _ <- Object3D.setRotation (rx) 0.0 0.0 p
  pure p
  
create :: Effect  Project
create = do
  sColor <- Three.createColor skyColor
  gColor <- Three.createColor groundColor
  dColor <- Three.createColor directionalColor
  dlight <-  DirectionalLight.create dColor dIntensity
  _ <- setPosition (-1.0) 1.75 1.0 dlight
  hlight <- HemisphereLight.create sColor gColor 0.75
  -- Json to Building types
  buildingsData <- loadBuildingsData
  let buildingsData' = doBuildings buildingsData 
      center = Projection.calculate buildingsData'
  boxes <- createBuildings buildingsData' center

  -- Streets
  streetsData <- loadStreetsData
  let streetsData' = doStreets streetsData 
  -- Using the center value from the buildings calculation
      -- center = Projection.calculate streetsData'
  lines <- createLines streetsData' center
  -- Plane
  plane <- createPlane
  pure $ BaseProject.Project { objects: Array.concat [boxes <> lines <> [plane] <> [dlight, hlight]], vectors: [] }

-- Remove duplication by making these polymorphic and use funtor
doBuildings 
  :: (Either (NonEmptyList ForeignError) (Array Building)) 
  -> Array Building

doBuildings b = case b of 
  Right f -> f
  -- Do not return a fake Building on error, handle upwards
  Left _ -> [Building { coordinates: [Coords {x: 0.0, y:0.0, z:0.0}]}]

doStreets 
  :: (Either (NonEmptyList ForeignError) (Array Street)) 
  -> Array Street

doStreets b = case b of 
  Right f -> f
  -- Do not return a fake Building on error, handle upwards
  Left _ -> [Street { coordinates: [Coords {x: 0.0, y:0.0, z:0.0}]}]

loadBuildingsData 
  :: Effect
      (Either 
        (NonEmptyList ForeignError) 
        (Array Building))
-- 
loadBuildingsData = do
  buildingsData <- MapLoader.loadBuildings
  pure $ runExcept (decodeJSON buildingsData :: _ (Array Building))

loadStreetsData 
  :: Effect
      (Either 
        (NonEmptyList ForeignError) 
        (Array Street))
-- 
loadStreetsData = do
  streetsData <- MapLoader.loadStreets
  pure $ runExcept (decodeJSON streetsData :: _ (Array Street))
