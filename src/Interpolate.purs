module Interpolate where

import Prelude
import Data.List.Lazy as LazyList
import Data.List (List, range, fromFoldable)  as StrictList
import Data.Int (toNumber)
import Data.List.ZipList (ZipList(..))
import Data.Tuple(Tuple(..))

import Point as P
import Line as L
import Square as SQ

type Steps = Int

interpolate :: Number -> Number -> Steps -> StrictList.List Number
interpolate a b s = 
  let inc = (b - a) / toNumber s
  in map (\x -> a + inc * toNumber x) $ StrictList.range 0 s -- \[x_n = x_i + \frac{x_f - x_i}{s} n\]

-- Reduce this to operate with better abstractions
multiplyTuple (Tuple p1 p2) = p1 * p2
sumTuple (Tuple p1 p2) = p1 + p2

interpolateSquare :: Steps -> SQ.Square -> StrictList.List P.Point
interpolateSquare s sq = 
  let points = SQ.getPoints sq
      lab = interpolateLine s $ L.create points.a points.b
      lac = interpolateLine s $ L.create points.a points.c
  in StrictList.fromFoldable $ sumTuple <$> cartesianProductOfPoints lab lac

cartesianProductOfPoints :: StrictList.List P.Point -> StrictList.List P.Point -> StrictList.List (Tuple P.Point P.Point)
cartesianProductOfPoints l1 l2 = do
  p1 <- l1
  p2 <- l2
  pure $ Tuple p1 p2

-- EOC educe this to operate with better abstractions  

  -- for each l1 elements
  -- multiply it for all l2 elements
  -- concat into a list
  -- repeat for the next element of l1

  

interpolateLine :: Steps -> L.Line -> StrictList.List P.Point
-- Change the destructuring of the line to a getLinePoints fn
interpolateLine s (L.Line {a:P.Point a, b:P.Point b}) =
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
