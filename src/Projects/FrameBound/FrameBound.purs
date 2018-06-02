module Projects.FrameBound
  (create, update)
where

import Data.List.Types
import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Random (RANDOM)
import Control.Monad.Eff.Random as Math
import Data.Array as Array
import Data.Array as Arry
import Data.List (List, (..), zipWith, (:))
import Data.List as List
import Data.Traversable (sequence_, traverse)
import Projects.BaseProject (Project)
import Projects.BaseProject as BaseProject
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

a = Point.create (902.0 / 10.0) 0.0 (438.0 / 10.0)
b = Point.create (899.0 / 10.0) 0.0 (282.0 / 10.0)
c = Point.create (888.0 / 10.0) 0.0 (298.0 / 10.0)
d = Point.create (890.0 / 10.0) 0.0 (454.0 / 10.0)
e = Point.create (902.0 / 10.0) 0.0 (438.0 / 10.0)

-- Create polygon from x points
-- map coords to local coord sytem

type ModuleEff a = ∀ e. Eff (random ∷ RANDOM, three :: THREE | e) a

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

createBoxes :: List Point -> ModuleEff (Array Object3D)
createBoxes ps = do
  boxColor <- Three.createColor boxColor
  boxMat <- MeshPhongMaterial.create boxColor true
  boxGs <- traverse (\_ -> BoxGeometry.create 4.0 4.0 4.0) ps
  boxMeshes <- traverse (flip Object3D.Mesh.create boxMat) boxGs
  _ <- sequence_ $ zipWith setPositionByPoint ps boxMeshes
  pure $ Array.fromFoldable boxMeshes

create :: ModuleEff Project
create = do
  boxes <- createBoxes $ Arry.toUnfoldable [a,b,c,d,e]
  pure $ BaseProject.Project { objects: Array.concat [boxes], vectors: [] }
