module Scene where

import Prelude (class Show)
import Point (Point)
import Line (Line)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)

data Scene = Scene 
  { points :: Array Point
   ,lines ::  Array Line
}

derive instance genScene :: Generic Scene _
instance showScene :: Show Scene where show = genericShow

-- This is not needed anymore...
-- unfoldScene :: Scene -> { points :: Array Point, lines :: Array Line }
-- unfoldScene (Scene s) = s