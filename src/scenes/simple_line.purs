module Scenes.SimpleLine where
  
import Point
import Line as Line
import Scene
import Data.List (List, toUnfoldable)

a = Point {x: 200.0, y: 120.0}
b = Point {x: 90.0, y: 50.0}
c = Line.interpolateLine a b 50

scene = Scene (toUnfoldable c)