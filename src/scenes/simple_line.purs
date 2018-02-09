module Scenes.SimpleLine where
  
import Point (create) as Point
import Line (create, interpolateLine) as Line
import Scene
import Data.List (List, toUnfoldable)

steps = 50

-- Export create function as helpers
la = Line.create (Point.create 200.0 120.0 0.0) (Point.create 90.0 50.0 0.0)

lai = Line.interpolateLine la steps

scene = Scene (toUnfoldable lai)