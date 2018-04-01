module Scenes.SquaresSurface 
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
import Scene as Scene

size :: Number
size = 50.0

a :: P.Point
a = P.create 0.0 0.0 0.0

b :: P.Point
b = P.create 0.0 0.0 size

c :: P.Point
c = P.create 0.0 size 0.0

d :: P.Point
d = P.create 0.0 size size

sq1 = SQ.create a b c d

-- Make Scene not require empty lines to be created
scene = Scene.create
  { points: [a, b, c, d]
  , lines: []
  , squares: [sq1]
  }