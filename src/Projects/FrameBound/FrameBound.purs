module Projects.FrameBound
  -- (create, update)
where

import Data.Either
import Data.List.Types
import Prelude

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
import Data.Newtype (class Newtype, unwrap)
import Data.Traversable (sequence_, traverse)
import Projects.BaseProject (Project)
import Projects.BaseProject as BaseProject
import Projects.FrameBound.MapLoader as MapLoader
import Pure3.Point (Point(..))
import Pure3.Point as Point
import Three as Three
import Three.Geometry.BoxGeometry as BoxGeometry
import Three.Materials.MeshPhongMaterial as MeshPhongMaterial
import Three.Object3D as Object3D
import Three.Object3D.Mesh as Object3D.Mesh
import Three.Types (Object3D, THREE, ThreeEff)
import Type.Row (Nil)

elements = 50
area = 500.0
boxColor = "#ff0000"

newtype Coords = Coords { x :: Number, y :: Number }
derive instance newtypeCoords :: Newtype Coords _
derive instance genCoords :: Generic Coords _
instance decCoords :: Decode Coords where
  decode = genericDecode opts

newtype Building = Building 
  { type :: String 
  , coordinates :: Array Coords
  }

opts = defaultOptions { unwrapSingleConstructors = true }

derive instance newtypeBuilding :: Newtype Building _
derive instance genBuilding :: Generic Building _
instance decBuilding :: Decode Building where
  decode = genericDecode opts

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
  let ps = buildingToPoint <$> bs
  boxColor <- Three.createColor boxColor
  boxMat <- MeshPhongMaterial.create boxColor true
  -- ps :: Array Array Point
  -- doBasement :: Array point -> Object3D (Shape?) <$> ps
  boxGs <- traverse (\_ -> BoxGeometry.create 4.0 4.0 4.0) ps
  boxMeshes <- traverse (flip Object3D.Mesh.create boxMat) boxGs
  -- _ <- sequence_ $ zipWith setPositionByPoint ps boxMeshes
  pure $ Array.fromFoldable boxMeshes

buildingToPoint :: Building -> Array Point
buildingToPoint (Building b) = 
  (\(Coords {x, y}) -> Point.create x 0.0 y) <$> _.coordinates b

create :: ModuleEff Project
create = do
  map <- loadBuildings
  boxes <- createBuildings $ doBuildings map
  pure $ BaseProject.Project { objects: Array.concat [boxes], vectors: [] }

-- use Functor instead of this function
doBuildings :: forall e. (Either (NonEmptyList ForeignError) (Array Building)) -> Array Building
doBuildings b = case b of 
  Right f -> f
  -- Do not return a fake Building on error, handle upwards
  Left _ -> [Building { type : "Polygon", coordinates: [Coords {x: 0.0, y:0.0}] }]

loadBuildings 
  :: forall e. 
  Eff (| e) 
    (Either 
      (NonEmptyList ForeignError) 
      (Array Building))
loadBuildings = do
  map <- MapLoader.loadMap
  pure $ runExcept (decodeJSON map :: _ (Array Building))
