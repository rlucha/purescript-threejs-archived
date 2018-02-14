module Scenes.SceneAsFunction where

import Prelude  
import Point (create) as Point
import Line (create, interpolateLine) as Line
import Scene
import Data.List (List, toUnfoldable)


la = Line.create (Point.create 0.0 0.0 0.0) (Point.create 50.0 0.0 70.0)

-- Create a way to pass JS integers and make points

scene a b c steps = 
  let p = Point.create a b c
  in Scene (toUnfoldable $ Line.interpolateLine steps $ Line.create (Point.create 0.0 0.0 0.0) p)


-- scene steps = Scene (toUnfoldable $ Line.interpolateLine steps la)