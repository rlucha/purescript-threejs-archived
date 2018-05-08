module Scenes.DotMatrix 
  (scene)
where

-- Todo Plane & Plane interpolation from 4 points (only 3 really needed)
-- Interpolate looks like an abstraction over n points
-- given 2 points, gives you a line, given 3+ gives you a surface

import Prelude
import Data.Array (fromFoldable)
-- import Data.List (List(..), (:), toUnfoldable, zipWith, concat)

import Point as P
import Line as L
import Square as SQ
import Transform as T
import Interpolate as Interpolate
import Scene as Scene

import Three (createGeometry, createVector3, pushVertices)
import Three.Types (ThreeT, Point)
import Three.Scene (addToScene)
import Three.Objects.Points (createPoints)
import Three.PointsMaterial (createPointsMaterial)

import Data.Traversable (traverse)

size = 1200.0
steps = 20

center = P.create (-size * 0.25) 0.0 (-size * 0.25)

a :: P.Point
a = P.create 0.0 0.0 0.0

b :: P.Point
b = P.create size 0.0 0.0

c :: P.Point
c = P.create 0.0 0.0 size

d :: P.Point
d = P.create size 0.0 size

sq1 :: SQ.Square
sq1 = SQ.createFromLines (L.create a b) (L.create c d)

sq1c = T.translateSquare sq1 center

sq1Points :: Array P.Point
sq1Points = fromFoldable $ Interpolate.interpolate sq1c steps

scene :: forall e. ThreeT Point
scene = do 
  g <- createGeometry
  m <- createPointsMaterial
  -- this scene 'unparsing' will be done at the scene graph parsing level
  -- eventually
  vs <- traverse Scene.createVectorFromPoint sq1Points
  -- here we are mutating g in JS... then using the reference in createPoints g
  -- should we express that effect somehow?
  g2 <- traverse (pushVertices g) vs
  p <- createPoints g2 m
  pure p

-- Explain why traverse works and pure fmap does not
-- traverse actually executes the effects , pure fmap does not...
-- traverese evaluates m b becase it needs to lift the value our of m to create t of m
-- fmap just needs to put b into f, without actually extracting the value
  -- _ <- traverse (pushVertices g) vs
  -- _ <- pure $ (pushVertices g) <$> vs


-- Scene now will use ThreeJS directly instead of just coordinate manipulation

-- var dotGeometry = new Geometry();
-- var dotMaterial = new PointsMaterial( { size: 1, sizeAttenuation: false } );    
-- dotGeometry.vertices.push(new Vector3(x, y, z));
-- var dot = new Points(dotGeometry, dotMaterial);
-- scene.add(dot)

-- Make Scene not require empty lines to be created
-- scene = Scene.create
--   { points: sq1Points
--   , lines: []
--   , squares: []
--   , meshes: []
--   }