module Scene where

import Prelude
import Point
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)

data Scene = Scene (Array Point)
derive instance genScene :: Generic Scene _
instance showScene :: Show Scene where show = genericShow