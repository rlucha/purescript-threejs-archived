module Point where

import Prelude
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Foreign.Class (class Encode)
import Data.Foreign.Generic (defaultOptions, genericEncode)

data Point = Point { x :: Number, y :: Number, z :: Number }

derive instance eqPoint :: Eq Point
derive instance genPoint :: Generic Point _
instance showPoint :: Show Point where show = genericShow
instance encodePoint :: Encode Point where
  encode = genericEncode $ defaultOptions {unwrapSingleConstructors = true}

instance semiringPoint :: Semiring Point where
  add = sumPoint
  mul = mulPoint
  zero = Point { x:0.0, y:0.0, z:0.0}
  one = Point { x:1.0, y:1.0, z:1.0}

sumPoint :: Point -> Point -> Point
sumPoint (Point a) (Point b) = Point { x: a.x + b.x , y: a.y + b.y, z: a.z + b.z}

mulPoint :: Point -> Point -> Point
mulPoint (Point a) (Point b) = Point { x: a.x * b.x , y: a.y * b.y, z: a.z * b.z}