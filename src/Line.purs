module Line where

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Int (toNumber)
import Data.List (List, range, fromFoldable)  as StrictList
import Data.List.Lazy as LazyList
import Data.List.ZipList (ZipList(..))
import Point (Point(..), create) as P

type Steps = Int

data Line = Line { a :: P.Point, b :: P.Point}
derive instance genLine :: Generic Line _
instance showLine :: Show Line where
  show = genericShow

create :: P.Point -> P.Point -> Line
create a b = Line { a: a, b: b}

-- This interpolation is to points
interpolate :: Number -> Number -> Steps -> StrictList.List Number
interpolate a b s = 
  let inc = (b - a) / toNumber s
  in map (\x -> a + inc * toNumber x) $ StrictList.range 0 s -- \[x_n = x_i + \frac{x_f - x_i}{s} n\]

interpolateLine :: Steps -> Line -> StrictList.List P.Point
interpolateLine s (Line {a:P.Point a, b:P.Point b}) =
  let ai = interpolate a.x b.x s
      bi = interpolate a.y b.y s
      ci = interpolate a.z b.z s
      -- Previously this was -----------
      -- in ri = zip ai $ zip bi ci
      -- in map (\(Tuple a b c) -> Point {x:a, y:b, z:c}) $ ri
      -- How to avoid getting nested Tuples?
      -- Lazy list and strict list are different list types, we need to differentiate them
      -- because ZipList only works on lazy lists and List Point is from Strict
      -- Then we use the applicative instance of ZipLlist to apply a 3ary function to 3 lists
      -- effectively using zipWith with 3 elements
      -- Applicative on lists is a cartesian product, applicative on Ziplist is an "ordered" function application 
      
      -- How does this work?
      -- P.create is a pure function
      ri = P.create 
          <$> ZipList (LazyList.fromFoldable ai) 
          <*> ZipList (LazyList.fromFoldable bi) 
          <*> ZipList (LazyList.fromFoldable ci)
    in StrictList.fromFoldable ri
