module Pure3.Circle where

import Prelude (class Show)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)

import Pure3.Point (Point)

type Radius = Number

-- Move to newtype, make a function to show if needed
-- get unwrap for free
data Circle = Circle { center :: Point, radius :: Radius }
derive instance genCircle :: Generic Circle _
instance showCircle :: Show Circle where
  show = genericShow

create :: Point -> Radius -> Circle
create c r = Circle { center: c, radius: r }

-- [NEWTYPE]
unwrap :: Circle -> { center :: Point, radius :: Radius }
unwrap (Circle {center, radius}) = {center, radius}
