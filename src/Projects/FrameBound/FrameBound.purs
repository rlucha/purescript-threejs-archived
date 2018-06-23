module Projects.FrameBound
  -- (create, update)
where

import Data.Either
import Data.List.Types
import Prelude

import Control.Extend ((<<=))
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Control.Monad.Except (runExcept)
import DOM (DOM)
import Data.Array as Array
import Data.Array as Arry
import Data.Foreign (ForeignError(..))
import Data.Foreign.Class (class Decode, class Encode)
import Data.Foreign.Generic (decodeJSON, defaultOptions, genericDecode, genericDecodeJSON, genericEncode)
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
import Pure3.Point (Point(..))
import Pure3.Point as Point
import Three as Three
import Three.Extras.Core.Shape as Shape
import Three.Geometry.BoxGeometry as BoxGeometry
import Three.Geometry.ExtrudeGeometry as ExtrudeGeometry
import Three.Materials.MeshPhongMaterial as MeshPhongMaterial
import Three.Object3D as Object3D
import Three.Object3D.Light.AmbientLight as AmbientLight
import Three.Object3D.Light.DirectionalLight as DirectionalLight
import Three.Object3D.Light.HemisphereLight as HemisphereLight
import Three.Object3D.Mesh as Object3D.Mesh
import Three.Types (Object3D, THREE, ThreeEff, Vector2)

import Projects.FrameBound.Types
import Projects.FrameBound.Projection as Projection

elements = 50
area = 500.0
boxColor = "#d2cbc5"
directionalColor = "#fff8e7"
skyColor = "#fff8e7"
groundColor = "7cfc00"

-- Create polygon from x points
-- map coords to local coord sytem

type ModuleEff a = ∀ e. Eff (console :: CONSOLE, three :: THREE, dom :: DOM | e) a

-- Can we call this function x times without passing a param? like sequence x times without input?
-- randomPoint :: ∀ e. Int -> ModuleEff Point
-- randomPoint a = do
--   x <- Math.random
--   y <- Math.random
--   pure $ Point.create (x*area - (area / 2.0)) 0.0 (y*area - (area / 2.0))

-- createRandomPoints :: ModuleEff (List Point )
-- createRandomPoints = traverse randomPoint (-elements..elements)

update :: Project -> Number -> ModuleEff Unit
update p t = pure unit

setPositionByPoint :: Point -> Object3D -> ThreeEff Unit
-- Maybe make Object3D.setPosition accept a Point || Vector3 so we can avoid unwrapping points here?
setPositionByPoint (Point {x, y, z}) o = Object3D.setPosition x y z o

createBuildings :: Array Building -> ModuleEff (Array Object3D)
createBuildings bs = do
  let ps = buildingCoordsToPoints <$> bs
  boxMeshes <- traverse buildingToMesh ps
  -- Do proper numbers here instead of magic
  sequence_ $ Object3D.setRotation (-90.0 * (Math.pi / 180.0)) 0.0 0.0 <$> boxMeshes
  pure $ Array.fromFoldable boxMeshes

buildingToMesh :: Array Point -> ModuleEff Object3D
buildingToMesh ps = do 
  let scale = 10.0 -- calculateProjection ps
  -- _ <- log $ show scale
  boxColor <- Three.createColor boxColor
  vs <- traverse (projectBuildingPoint scale) ps
  sh <- Shape.create vs
  ex <- ExtrudeGeometry.create 1.0 sh 
  mat <- MeshPhongMaterial.create boxColor true
  Object3D.Mesh.create ex mat

buildingCoordsToPoints :: Building -> Array Point
buildingCoordsToPoints (Building b) = 
  (\(Coords {x, y, z}) -> Point.create x y z) <$> _.coordinates b

-- project to desired scale
-- get example working in the js only playground and reproduce here
-- Using 3d points, we do not need to do most of this stuff and just project those into the view
projectBuildingPoint :: Number -> Point -> ModuleEff Vector2
projectBuildingPoint sc (Point {x, y, z}) = 
  Three.createVector2 x' z'
  where x' = ((x * sc) + (10000.0 * sc))
        z' = ((z * sc) - (6705000.5 * sc))


-- projectToCenter :: Array Building -> Array Building
-- projectToCenter bs = 
--   let maxX  = fromMaybe 0.0 $ maximum $ _.x <<< unwrap <$> bs
--       maxZ  = fromMaybe 0.0 $ maximum $ _.z <<< unwrap <$> bs
--       scale = fromMaybe 0.0 $ maximum [maxX, maxZ]
--   in (scale / 100.0) 

create :: ModuleEff Project
create = do
  sColor <- Three.createColor skyColor
  gColor <- Three.createColor groundColor
  dColor <- Three.createColor directionalColor
  dlight <-  DirectionalLight.create dColor 0.75
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
  log $ show $ _.x center
  log $ show $ _.z center
  boxes <- createBuildings buildingsData'
  pure $ BaseProject.Project { objects: Array.concat [boxes <> [dlight, hlight]], vectors: [] }

-- use Functor instead of this function
doBuildings :: forall e. (Either (NonEmptyList ForeignError) (Array Building)) -> Array Building
doBuildings b = case b of 
  Right f -> f
  -- Do not return a fake Building on error, handle upwards
  Left _ -> [Building { coordinates: [Coords {x: 0.0, y:0.0, z:0.0}]}]

loadBuildingsData 
  :: forall e. 
  Eff (| e) 
    (Either 
      (NonEmptyList ForeignError) 
      (Array Building))
loadBuildingsData = do
  map <- MapLoader.loadMap
  pure $ runExcept (decodeJSON map :: _ (Array Building))
