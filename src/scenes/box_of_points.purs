module Scenes.BoxOfPoints where

-- TODO reimplement BoxOfPoints from Line create constructor

import Prelude
import Data.List (List(..), (:), toUnfoldable, zipWith, concat)

import Point as P
import Line as L
import Scene

steps = 25
size = 50.0
center = -size*0.5

interpolateLine a b = L.interpolateLine steps (L.create a b)
interpolatedPlane l0 l1 = concat $ zipWith interpolateLine l0 l1

-- MOVE to translate module
translate x y z g = (P.create x y z) + g
translateX x g = translate x 0.0 0.0 g
translateY y g = translate 0.0 y 0.0 g
translateZ z g = translate 0.0 0.0 z g

-- Points
a = P.create 0.0 0.0 0.0
b = P.create 0.0 0.0 size
c = P.create 0.0 size 0.0
d = P.create 0.0 size size
e = P.create size 0.0 0.0
f = P.create size size 0.0
g = P.create size 0.0 size

-- Lines
la = interpolateLine a b
lb = interpolateLine c d
lc = interpolateLine a e
ld = interpolateLine c f
le = interpolateLine e g

-- Planes
planeYZ = interpolatedPlane la lb
planeYX = interpolatedPlane lc ld
planeZX = interpolatedPlane la le
planeYZ2 = translateX size <$> planeYZ
planeYX2 = translateZ size <$> planeYX
planeZX2 = translateY size <$> planeZX

-- Binding notes
-- x >>= f = do y <- x
--              f y
-- cube = do geo  <- planeYZ <> planeYX <> planeZX <> planeYZ2 <> planeYX2 <> planeZX2
--           translate center center center <$> pure geo

-- Why do I need to use pure here? is it because bind uses the monadic context? 
-- is there something similar to bind without that?
cube =  planeYZ <> planeYX <> planeZX <> planeYZ2 <> planeYX2 <> planeZX2 
        >>= (<$>) (translate center center center) <<< pure

scene = Scene (toUnfoldable cube)