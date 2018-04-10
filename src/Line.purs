module Line where

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Point (Point) as P

data Line = Line { a :: P.Point, b :: P.Point}
derive instance genLine :: Generic Line _
instance showLine :: Show Line where
  show = genericShow

create :: P.Point -> P.Point -> Line
create a b = Line { a: a, b: b}