module Pure3.Interpolate where

import Prelude
import Math as Math

import Data.List ((..))
import Data.List as StrictList
import Data.List.Lazy as LazyList
import Data.Int (toNumber)
import Data.List.ZipList (ZipList(..))

import Control.Apply (lift2)

import Pure3.Point (Point(..))
import Pure3.Point as Point
import Pure3.Line (Line(..))
import Pure3.Line as Line
import Pure3.Circle (Circle)
import Pure3.Circle as Circle
import Pure3.Square (Square)
import Pure3.Square as Square

type Steps = Int

interpolateRange :: Number -> Number -> Int -> StrictList.List Number
interpolateRange from to s = 
  let inc = (to - from) / toNumber s
  in map (\x -> from + inc * toNumber x) (StrictList.range 0 s)
  -- \[x_n = x_i + \frac{x_f - x_i}{s} n\]

degToRad :: Number -> Number
degToRad n = n * (180.0 / Math.pi)

class Interpolatable a where
  interpolate :: Steps -> a -> StrictList.List Point

instance interpolateCircle :: Interpolatable Circle where
  interpolate s c = 
    let {center, radius} = Circle.unwrap c
        inc = 360.0 / degToRad (toNumber s)
        degs = ((*) inc) <$> toNumber <$> 0..s
        cosR = (*) radius <<< Math.cos
        sinR = (*) radius <<< Math.sin
        -- Is there a way to chain this fmaps more beautifully?
        points =  (+) center <$> (\r -> Point.create (cosR r) (sinR r) 0.0) <$> degs
    --  uncurry is gonna take a binary function and make it a unary function over Tuples
    -- cartesianProductOfPoints :: (*) <$> lab <*> lac
    in points

instance interpolateSquare :: Interpolatable Square where
  interpolate s sq =
    let points = Square.getPoints sq
        lab = interpolate s (Line.create points.a points.b)
        lac = interpolate s (Line.create points.a points.c)
    --  uncurry is gonna take a binary function and make it a unary function over Tuples
    -- cartesianProductOfPoints :: (*) <$> lab <*> lac
    in StrictList.fromFoldable $ lift2 (+) lab lac -- (*) <$> lab <*> lac

-- something :: ∀ a. Interpolatable a => a -> StrictList.List Point
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
instance il :: Interpolatable Line where
  interpolate s (Line {a:Point a, b:Point b}) = 
  -- Change the destructuring of the line to a getLinePoints fn
    let ai = interpolateRange a.x b.x s
        bi = interpolateRange a.y b.y s
        ci = interpolateRange a.z b.z s
        ri = Point.create 
            <$> ZipList (LazyList.fromFoldable ai) 
            <*> ZipList (LazyList.fromFoldable bi) 
            <*> ZipList (LazyList.fromFoldable ci)
    in StrictList.fromFoldable ri

-- This should be a combination of basic interpolation and a ziggy line?
-- That would need to create a square from two lines nad not only from four points

-- getDistanceFromLine :: Line -> Point
-- getDistanceFromLine Nil = P.create 0.0 0.0 0.0
-- getDistanceFromLine (Line l) = StrictList.take 2 lab 

-- -- This is a failed tesselation prototype
-- interpolateStarSquare :: SQ.Square -> Int -> StrictList.List Point
-- interpolateStarSquare s sq = 
--   let points = SQ.getPoints sq
--       lab = interpolate s (L.create points.a points.b)
--       distancePoint = (*) (P.create 0.25 1.0 1.0) $ foldr (-) P.zeroPoint $ StrictList.take 2 lab
--       -- zigPoint = 
--       --   case distance of
--       --     Nil -> f
--       --     (distance:Nil) -> distance
--       -- lac = interpolate (L.create points.a points.c) s
--       lac = zigPoints distancePoint (P.negatePoint distancePoint) $ interpolate (L.create points.a points.c) s
--   --  uncurry is gonna take a binary function and make it a unary function over Tuples
--   -- cartesianProductOfPoints :: (*) <$> lab <*> lac
--   in StrictList.fromFoldable $ lift2 (+) lab lac -- (*) <$> lab <*> lac
