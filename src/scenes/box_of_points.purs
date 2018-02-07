module Scenes.BoxOfPoints where


import Prelude
import Data.List (List(..), (:), toUnfoldable, zipWith, concat)

import Point
import Line as Line
import Scene

steps = 10
size = 200.0

a = Point {x: 0.0, y: 0.0, z: 0.0}
b = Point {x: 0.0, y: 0.0, z: size}
c = Point {x: 0.0, y: size, z: 0.0}
d = Point {x: 0.0, y: size, z: size}
e = Point {x: size, y: 0.0, z: 0.0}
f = Point {x: size, y: size, z: 0.0}
g = Point {x: size, y: 0.0, z: size}

-- Maybe Line should be a constructor given two points?
-- Then we interpolate the line in an interpolator module?

la = Line.interpolateLine a b steps
lb = Line.interpolateLine c d steps
lc = Line.interpolateLine a e steps
ld = Line.interpolateLine c f steps
le = Line.interpolateLine e g steps

-- Add multiplication on any axis to "translate object"
-- Add object copy, and the concept of object

-- How to create a plane with limits? interpolation of two lines?
planeYZ = concat $ zipWith (\a b -> Line.interpolateLine a b steps) la lb
planeYX = concat $ zipWith (\a b -> Line.interpolateLine a b steps) lc ld
planeZX = concat $ zipWith (\a b -> Line.interpolateLine a b steps) la le

-- TranslateY is just + on x0, yN, z0
planeYZ2 = ((+) (Point {x:size, y:0.0, z:0.0})) <$> planeYZ
planeYX2 = ((+) (Point {x:0.0, y:0.0, z:size})) <$> planeYX
planeZX2 = ((+) (Point {x:0.0, y:size, z:0.0})) <$> planeZX

cube = planeYZ <> planeYX <> planeZX <> planeYZ2 <> planeYX2 <> planeZX2

-- Offseting by adding negative size / 2
centeredCube = ((+) (Point {x:(-size*0.5), y:(-size*0.5), z:(-size*0.5)})) <$> cube

-- thing = concat $ zipWith (\a b -> Line.interpolateLine a b steps) plane lc

scene = Scene (toUnfoldable centeredCube) -- Why is this plane not in the right orientation? I had expected it to be in the yz plane