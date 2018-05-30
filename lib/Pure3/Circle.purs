module Pure3.Circle where

import Prelude (class Show)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)

import Pure3.Point (Point)

type Radius = Number

data Circle = Circle { center :: Point, radius :: Radius }
derive instance genCircle :: Generic Circle _
instance showCircle :: Show Circle where
  show = genericShow

create :: Point -> Radius -> Circle
create c r = Circle { center: c, radius: r }

-- Is there a way to pass a record-like datatype to a record automatically?
unwrap :: Circle -> { center :: Point, radius :: Radius }
unwrap (Circle {center, radius}) = {center, radius}

-- TODO
-- How to write a function that accepts different number of params and types?
-- create :: Point -> Point -> Point -> Point -> Square
-- create :: L.Line -> L.Line -> Square
-- create .... = implementation 1 || implemenetation 2
