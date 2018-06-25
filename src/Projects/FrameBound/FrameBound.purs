module Projects.FrameBound
  -- (create, update)
where

import Data.Either
import Data.List.Types
import Prelude
import Projects.FrameBound.Types

import Control.Extend ((<<=))
import Effect
import Effect.Class.Console as Console
import Control.Monad.Except (runExcept)

import Data.Array as Array
import Foreign (ForeignError(..))
import Foreign.Class (class Decode, class Encode)
import Foreign.Generic (decodeJSON, defaultOptions, genericDecode, genericDecodeJSON, genericEncode)


import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.List (List, (..), zipWith, (:))
import Data.List as List
import Data.Maybe (fromMaybe)
import Data.Newtype (class Newtype, unwrap)
import Data.Traversable (maximum, sequence_, traverse, traverse_)
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
import Three.Materials.MeshPhongMaterial as MeshPhongMaterial
import Three.Object3D (setPosition)
import Three.Object3D as Object3D
import Three.Object3D.Light.AmbientLight as AmbientLight
import Three.Object3D.Light.DirectionalLight as DirectionalLight
import Three.Object3D.Light.HemisphereLight as HemisphereLight
import Three.Object3D.Mesh as Object3D.Mesh
import Three.Types (Object3D, Vector2)

elements = 50
area = 500.0
boxColor = "#e3cdac"
directionalColor = "#ffffff"
dIntensity = 0.3
skyColor = "#fff8e7"
groundColor = "7cfc00"

-- Create polygon from x points
-- map coords to local coord sytem

-- Can we call this function x times without passing a param? like sequence x times without input?
-- randomPoint :: ∀ e. Int -> Effect Point
-- randomPoint a = do
--   x <- Math.random
--   y <- Math.random
--   pure $ Point.create (x*area - (area / 2.0)) 0.0 (y*area - (area / 2.0))

-- createRandomPoints :: Effect (List Point )
-- createRandomPoints = traverse randomPoint (-elements..elements)

update :: Project -> Number -> Effect  Unit
update p t = pure unit

setPositionByPoint :: Point -> Object3D -> Effect  Unit
-- Maybe make Object3D.setPosition accept a Point || Vector3 so we can avoid unwrapping points here?
setPositionByPoint (Point {x, y, z}) o = Object3D.setPosition x y z o

buildingToMesh :: Array Point -> Effect Object3D
buildingToMesh ps = do 
  let scale = 10.0 -- calculateProjection ps
  boxColor <- Three.createColor boxColor
  vs <- traverse (projectBuildingPoint scale) ps
  sh <- Shape.create vs
  -- Pass estrusion from config, eventually use LIDAR
  ex <- ExtrudeGeometry.create 2.0 sh 
  mat <- MeshPhongMaterial.create boxColor true
  Object3D.Mesh.create ex mat

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
  -- buildingsData' <- doBuildings buildingsData
  -- scale buildingsData to proper scale
  -- buildingsData' <- projectToCenter buildingsData
  -- Building types to meshes
  -- PROJECTION HERE <<<<<-------------------------
  -- pas center to createBuildings, then buildingCoordsToPoints
  boxes <- createBuildings buildingsData' center
  pure $ BaseProject.Project { objects: Array.concat [boxes <> [dlight, hlight]], vectors: [] }

-- use Functor instead of this function
doBuildings 
  :: (Either (NonEmptyList ForeignError) (Array Building)) 
  -> Array Building
-- 
doBuildings b = case b of 
  Right f -> f
  -- Do not return a fake Building on error, handle upwards
  Left _ -> [Building { coordinates: [Coords {x: 0.0, y:0.0, z:0.0}]}]

loadBuildingsData 
  :: Effect
      (Either 
        (NonEmptyList ForeignError) 
        (Array Building))
-- 
loadBuildingsData = do
  map <- MapLoader.loadMap
  pure $ runExcept (decodeJSON map :: _ (Array Building))
