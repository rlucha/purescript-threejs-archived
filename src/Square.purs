module Square where

import Prelude (class Show)

import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Point (Point) as P
import Line (Line(..)) as L
type Steps = Int

data Square = Square { a :: P.Point, b :: P.Point, c :: P.Point, d :: P.Point }
derive instance genSquare :: Generic Square _
instance showSquare :: Show Square where
  show = genericShow

create :: P.Point -> P.Point -> P.Point -> P.Point -> Square
create a b c d = Square { a: a, b: b, c: c, d: d }

-- MultiParamTypeClasses ? for parametric dispatch?
createFromLines :: L.Line -> L.Line -> Square
createFromLines (L.Line la) (L.Line lb) = Square { a: la.a, b: la.b, c: lb.a, d: lb.b}

-- Is there a way to pass a record-like datatype to a record automatically?
getPoints :: Square -> { a :: P.Point, b :: P.Point, c :: P.Point, d :: P.Point }
getPoints (Square {a, b, c, d}) = {a, b, c, d}

-- TODO
-- How to write a function that accepts different number of params and types?
-- create :: P.Point -> P.Point -> P.Point -> P.Point -> Square
-- create :: L.Line -> L.Line -> Square
-- create .... = implementation 1 || implemenetation 2