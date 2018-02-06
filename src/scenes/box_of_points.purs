module Scenes.BoxOfPoints where

import Prelude
import Point
import Line as Line
import Scene
import Data.List (List(..), (:), toUnfoldable, zipWith, concat)
import Data.Traversable (sequence)

steps = 25

linesH = 10
linesV = 10

a = Point {x: 0.0, y: 0.0}
b = Point {x: 100.0, y: 0.0}

c = Point {x: 0.0, y: 100.0}
d = Point {x: 100.0, y: 100.0}

la = Line.interpolateLine a b steps
lb = Line.interpolateLine c d steps

-- How to create a plane with limits? interpolation of two lines?
plane = concat $ zipWith (\x y -> Line.interpolateLine x y steps) la lb

thing = concat $ sequence (la : lb : Nil)
-- doCube = map( )

scene = Scene (toUnfoldable plane)