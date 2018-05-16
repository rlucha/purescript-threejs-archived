module Pure3.Circle where

import Prelude (class Show)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)

import Pure3.Point (Point) as P

type Radius = Number

data Circle = Circle { center :: P.Point, radius :: Radius }
derive instance genCircle :: Generic Circle _
instance showCircle :: Show Circle where
  show = genericShow

create :: P.Point -> Radius -> Circle
create c r = Circle { center: c, radius: r }

-- Is there a way to pass a record-like datatype to a record automatically?
unwrap :: Circle -> { center :: P.Point, radius :: Radius }
unwrap (Circle {center, radius}) = {center, radius}

-- TODO
-- How to write a function that accepts different number of params and types?
-- create :: P.Point -> P.Point -> P.Point -> P.Point -> Square
-- create :: L.Line -> L.Line -> Square
-- create .... = implementation 1 || implemenetation 2
