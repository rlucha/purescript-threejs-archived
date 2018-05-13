module Pure3.Line where

import Prelude
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)

import Pure3.Point (Point) as P

data Line = Line { a :: P.Point, b :: P.Point}
derive instance genLine :: Generic Line _
instance showLine :: Show Line where
  show = genericShow

create :: P.Point -> P.Point -> Line
create a b = Line { a: a, b: b}

-- Is there a way to pass a record-like datatype to a record automatically?
getPoints :: Line -> { a :: P.Point, b :: P.Point }
getPoints (Line {a, b}) = {a, b}
