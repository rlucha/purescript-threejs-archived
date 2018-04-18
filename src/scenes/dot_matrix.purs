module Scenes.DotMatrix 
  (scene)
where

-- Todo Plane & Plane interpolation from 4 points (only 3 really needed)
-- Interpolate looks like an abstraction over n points
-- given 2 points, gives you a line, given 3+ gives you a surface

import Prelude
-- import Data.List (List(..), (:), toUnfoldable, zipWith, concat)

import Point as P
import Line as L
import Square as SQ
import Transform as T
import Interpolate as Interpolate
import Scene as Scene

import Data.Array (fromFoldable)


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

-- Make Scene not require empty lines to be created
scene = Scene.create
  { points: sq1Points
  , lines: []
  , squares: []
  , meshes: []
  }