module Scenes.SquaresSurface 
  (scene)
where

-- Todo Plane & Plane interpolation from 4 points (only 3 really needed)
-- Interpolate looks like an abstraction over n points
-- given 2 points, gives you a line, given 3+ gives you a surface

import Prelude
-- import Data.List (List(..), (:), toUnfoldable, zipWith, concat)

import Point as P
import Square as SQ
import Transform as T
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

transP = P.create 10.0 0.0 0.0
scaleF = T.scaleSquare 0.75

sq1 = SQ.create a b c d
sq2 =  scaleF $ T.translateSquare sq1 transP
sq3 =  scaleF $ T.translateSquare sq2 transP
sq4 =  scaleF $ T.translateSquare sq3 transP
sq5 =  scaleF $ T.translateSquare sq4 transP

-- Make Scene not require empty lines to be created
scene = Scene.create
  { points: [a, b, c, d]
  , lines: []
  , squares: [sq1, sq2, sq3, sq4, sq5]
  }