module Line where

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Int (toNumber)
import Data.List (List, (..), zip)
import Data.Tuple (Tuple(..))
import Point (Point(..))

type Steps = Int

data Line = Line { a :: Point, b :: Point}
derive instance genLine :: Generic Line _
instance showLine :: Show Line where
  show = genericShow

create :: Point -> Point -> Line
create a b = Line { a: a, b: b}

interpolate :: Number -> Number -> Steps -> List Number
interpolate a b s = 
  let inc = (b - a) / toNumber s
  in map (\x -> a + inc * toNumber x) $ 0..s -- \[x_n = x_i + \frac{x_f - x_i}{s} n\]

-- (Line {a:Point ap, b:Point b})
interpolateLine :: Line -> Steps -> List Point
interpolateLine (Line {a:Point a, b:Point b}) s =
  let ai = interpolate a.x b.x s
      bi = interpolate a.y b.y s
      ci = interpolate a.z b.z s
      ri = zip ai $ zip bi ci
    -- in map (\(Tuple a b c) -> Point {x:a, y:b, z:c}) $ ri
    -- How to avoid getting nested Tuples?
    in map (\(Tuple x (Tuple y z)) -> Point {x, y, z}) ri 

-- Amarr's suggestion, use applicative of List
-- f x y z = Tuple3 x y z
-- ri = toList (f <$> ZipList bi <*> (ZipList ci) <*> (ZipList ai))

-- zip3 :: List -> List -> List -> List
-- zip3 (a:as) (b:bs) (c:cs) = (Tuple (a b c) : (zip3 as bs cs))