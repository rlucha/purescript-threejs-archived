module Scenes.SimpleLine where
  
import Point (create) as Point
import Line (create, interpolateLine) as Line
import Scene
import Data.List (List, toUnfoldable)

steps = 50

la = Line.create (Point.create 0.0 0.0 0.0) (Point.create 50.0 0.0 70.0)

lai = Line.interpolateLine steps la 

scene = Scene (toUnfoldable lai)