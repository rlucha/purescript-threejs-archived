module Pure3.Square where

import Prelude (class Show)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)

import Pure3.Point (Point)
import Pure3.Line (Line(..))

type Steps = Int

data Square = Square { a :: Point, b :: Point, c :: Point, d :: Point }
derive instance genSquare :: Generic Square _
instance showSquare :: Show Square where
  show = genericShow

-- [NEWTYPE]
create :: Point -> Point -> Point -> Point -> Square
create a b c d = Square { a: a, b: b, c: c, d: d }

-- MultiParamTypeClasses ? for parametric dispatch?
createFromLines :: Line -> Line -> Square
createFromLines (Line la) (Line lb) = Square { a: la.a, b: la.b, c: lb.a, d: lb.b}

-- Is there a way to pass a record-like datatype to a record automatically?
getPoints :: Square -> { a :: Point, b :: Point, c :: Point, d :: Point }
getPoints (Square {a, b, c, d}) = {a, b, c, d}

-- TODO
-- How to write a function that accepts different number of params and types?
-- create :: Point -> Point -> Point -> Point -> Square
-- create :: Line -> Line -> Square
-- create .... = implementation 1 || implemenetation 2
