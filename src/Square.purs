module Square where

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Point (Point(..)) as P
import Data.List

type Steps = Int

data Square = Square { a :: P.Point, b :: P.Point, c :: P.Point, d :: P.Point }
derive instance genSquare :: Generic Square _
instance showSquare :: Show Square where
  show = genericShow

create :: P.Point -> P.Point -> P.Point -> P.Point -> Square
create a b c d = Square { a: a, b: b, c: c, d: d }

-- Is there a way to pass a record-like datatype to a record automatically?
getPoints :: Square -> { a :: P.Point, b :: P.Point, c :: P.Point, d :: P.Point }
getPoints (Square {a, b, c, d}) = {a, b, c, d}