module Interpolate where

import Prelude
import Data.List.Lazy as LazyList
import Data.List (List, range, fromFoldable)  as StrictList
import Data.Int (toNumber)
import Data.List.ZipList (ZipList(..))
import Control.Apply (lift2)
import Point as P
import Line as L
import Square as SQ

type Steps = Int

interpolateRange :: Number -> Number -> Int -> StrictList.List Number
interpolateRange from to s = 
  let inc = (to - from) / toNumber s
  in map (\x -> from + inc * toNumber x) (StrictList.range 0 s)
  -- \[x_n = x_i + \frac{x_f - x_i}{s} n\]


class Interpolatable a where
  interpolate :: a -> Steps -> StrictList.List P.Point

instance interpolateSquare :: Interpolatable SQ.Square where
  interpolate sq s = 
    let points = SQ.getPoints sq
        lab = interpolate (L.create points.a points.b) s
        lac = interpolate (L.create points.a points.c) s
    --  uncurry is gonna take a binary function and make it a unary function over Tuples
    -- cartesianProductOfPoints :: (*) <$> lab <*> lac
    in StrictList.fromFoldable $ lift2 (+) lab lac -- (*) <$> lab <*> lac

-- something :: forall a. Interpolatable a => a -> StrictList.List P.Point
-- something s = interpolate s 10

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
instance il :: Interpolatable L.Line where
  interpolate (L.Line {a:P.Point a, b:P.Point b}) s = 
  -- Change the destructuring of the line to a getLinePoints fn
    let ai = interpolateRange a.x b.x s
        bi = interpolateRange a.y b.y s
        ci = interpolateRange a.z b.z s
        ri = P.create 
            <$> ZipList (LazyList.fromFoldable ai) 
            <*> ZipList (LazyList.fromFoldable bi) 
            <*> ZipList (LazyList.fromFoldable ci)
    in StrictList.fromFoldable ri