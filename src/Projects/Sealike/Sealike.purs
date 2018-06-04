module Projects.Sealike 
  (create, update)
where

import Prelude

import Data.Array as Array
import Data.List (List)
import Data.Traversable (traverse, traverse_)
import Math as Math
import Projects.BaseProject as BaseProject
import Projects.Sealike.SeaMaterial (createSeaMaterial)
import Pure3.Interpolate as Interpolate
import Pure3.Line as Line
import Pure3.Point as Point
import Pure3.Square as Square
import Pure3.Transform as Transform
import Pure3.Types (Point)
import Three as Three
import Three.Object3D as Object3D
import Three.Object3D.Points as Object3D.Points
import Three.Types (ThreeEff, Vector3)

size = 3000.0
steps = 60
freq = 0.003
speed = 0.025
amplitude = 40.0

center :: Point
center = Point.create (-size * 0.25) 0.0 (-size * 0.25)

a = Point.create 0.0 0.0 0.0
b = Point.create size 0.0 0.0
c = Point.create 0.0 0.0 size
d = Point.create size 0.0 size
sq1 = Square.createFromLines (Line.create a b) (Line.create c d)
sq1c = Transform.translateSquare sq1 center

sq1Points :: List Point
sq1Points = Interpolate.interpolate steps sq1c 

updateVector :: Number -> Vector3 -> ThreeEff Unit
updateVector t v = do
  vpos <- Three.getVector3Position v
  let delta = (vpos.x + vpos.z) * freq
      waveY = (Math.cos (delta + speed * t)) * amplitude
      wave2 = (Math.cos (vpos.z + speed * t)) * amplitude * 0.4
  Three.updateVector3Position vpos.x ( waveY + wave2) vpos.z v

update :: BaseProject.Project -> Number -> ThreeEff Unit
update p t = 
  let vs  = BaseProject.getProjectVectors p
      g   = BaseProject.getProjectObjects p
  in traverse_ (updateVector t) vs *> traverse_ Object3D.forceVerticesUpdate g

create :: ThreeEff BaseProject.Project
create = do
  -- here we are mutating g in JS... then using the reference in create g
  -- should we express that effect somehow?
  g <- Three.createGeometry
  m <- createSeaMaterial
  vs <- traverse BaseProject.createVector3FromPoint sq1Points
  _ <- traverse_ (Three.pushVertices g) vs
  p <- Object3D.Points.create g m
  pure $ BaseProject.Project { objects: [p], vectors: Array.fromFoldable vs }
