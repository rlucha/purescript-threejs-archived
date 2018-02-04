module Point where
import Prelude

data Point = Point { x :: Number, y :: Number }

instance showPoint :: Show Point where
  show (Point p) = show p.x <> " , " <> show p.y

instance semiringPoint :: Semiring Point where
  add = sumPoint
  mul = mulPoint
  zero = Point { x:0.0, y:0.0 }
  one = Point { x:1.0, y:1.0 }

sumPoint :: Point -> Point -> Point
sumPoint (Point a) (Point b) = Point { x: a.x + b.x , y: a.y + b.y}

mulPoint :: Point -> Point -> Point
mulPoint (Point a) (Point b) = Point { x: a.x * b.x , y: a.y * b.y}