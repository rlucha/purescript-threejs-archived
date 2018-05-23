module Projects.Sealike 
  (create, update)
where

import Data.Array (fromFoldable)
import Data.List (List)
import Data.Traversable (traverse, traverse_)
import Math (cos) as Math
import Prelude (Unit, bind, negate, pure, ($), (*), (*>), (+))
import Projects.BaseProject (Project(..), getProjectObjects, getProjectVectors, createVectorFromPoint) as BaseProject
import Projects.Sealike.SeaMaterial (createSeaMaterial)
import Pure3.Interpolate as Interpolate
import Pure3.Line as L
import Pure3.Point as P
import Pure3.Square as SQ
import Pure3.Transform as T
import Three (createGeometry, getVector3Position, pushVertices, updateVector3Position)
import Three.Object3D (forceVerticesUpdate) as Object3D
import Three.Object3D.Points (create) as Object3D.Points
import Three.Types (ThreeEff, Vector3)

size = 3000.0
steps = 60
freq = 0.003
speed = 2.0
amplitude = 40.0

center :: P.Point
center = P.create (-size * 0.25) 0.0 (-size * 0.25)

a = P.create 0.0 0.0 0.0
b = P.create size 0.0 0.0
c = P.create 0.0 0.0 size
d = P.create size 0.0 size
sq1 = SQ.createFromLines (L.create a b) (L.create c d)
sq1c = T.translateSquare sq1 center

sq1Points :: List P.Point
sq1Points = Interpolate.interpolate steps sq1c 

updateVector :: Number -> Vector3 -> ThreeEff Unit
updateVector t v = do
  vpos <- getVector3Position v
  let delta = (vpos.x + vpos.z) * freq
      waveY = (Math.cos (delta + speed * t)) * amplitude
      wave2 = (Math.cos (vpos.z + speed * t)) * amplitude * 0.4
  updateVector3Position vpos.x ( waveY + wave2) vpos.z v

update :: BaseProject.Project -> Number -> ThreeEff Unit
update p t = 
  let vs  = BaseProject.getProjectVectors p
      g   = BaseProject.getProjectObjects p
  in traverse_ (updateVector t) vs *> traverse_ Object3D.forceVerticesUpdate g

create :: ThreeEff BaseProject.Project
create = do
  -- here we are mutating g in JS... then using the reference in create g
  -- should we express that effect somehow?
  g <- createGeometry
  m <- createSeaMaterial
  vs <- traverse BaseProject.createVectorFromPoint sq1Points
  _ <- traverse_ (pushVertices g) vs
  p <- Object3D.Points.create g m
  pure $ BaseProject.Project { objects: [p], vectors: fromFoldable vs }
