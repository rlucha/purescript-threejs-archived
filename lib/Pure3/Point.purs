module Pure3.Point where

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Newtype (class Newtype)

newtype Point = Point { x :: Number, y :: Number, z :: Number }

derive instance newPoint :: Newtype Point _
derive instance eqPoint :: Eq Point
derive instance genPoint :: Generic Point _
instance showPoint :: Show Point where show = genericShow

instance semiringPoint :: Semiring Point where
  add = sumPoint
  mul = mulPoint
  zero = zeroPoint
  one = Point { x:1.0, y:1.0, z:1.0}

instance ringPoint :: Ring Point where
  sub = subPoint

-- [NEWTYPE]
unwrap :: Point -> { x :: Number, y :: Number, z :: Number }
unwrap (Point {x, y, z}) = {x, y, z}

-- a way to fetch a record value from label?
getZ :: Point -> Number
getZ p = (\r -> r.z) $ unwrap p 

zeroPoint :: Point
zeroPoint = Point { x:0.0, y:0.0, z:0.0}

create :: Number -> Number -> Number -> Point
create x y z = Point 
  { x: x
  , y: y
  , z: z
  }

sumPoint :: Point -> Point -> Point
sumPoint (Point a) (Point b) = Point 
  { x: a.x + b.x 
  , y: a.y + b.y
  , z: a.z + b.z
  }

subPoint :: Point -> Point -> Point
subPoint (Point a) (Point b) = Point 
  { x: a.x - b.x 
  , y: a.y - b.y
  , z: a.z - b.z
  }

mulPoint :: Point -> Point -> Point
mulPoint (Point a) (Point b) = Point
  { x: a.x * b.x 
  , y: a.y * b.y
  , z: a.z * b.z
  }

negatePoint :: Point -> Point 
negatePoint (Point a) = create (negate a.x) (negate a.y) (negate a.z)
