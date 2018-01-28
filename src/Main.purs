module Main where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)

newtype Point = Point { x :: Number, y :: Number }

instance showPoint :: Show Point where
  show (Point p) = show p.x <> "," <> show p.y

instance semiringPoint :: Semiring Point where
  add = sumPoint
  mul = mulPoint
  zero = Point { x:0.0, y:0.0 }
  one = Point { x:1.0, y:1.0 }

a :: Point
a = Point {x: 1.0, y: 2.0}

b :: Point
b = Point {x: 2.0, y: 3.0}

-- getX :: Point -> Number
-- getX {x,y} = x

-- getY :: Point -> Number
-- getY {x,y} = y

sumPoint :: Point -> Point -> Point
sumPoint (Point a) (Point b) = Point { x: a.x + b.x , y: a.y + b.y}

mulPoint :: Point -> Point -> Point
mulPoint (Point a) (Point b) = Point { x: a.x * b.x , y: a.y * b.y}

main :: Point -> Point -> forall e. Eff (console :: CONSOLE | e) Unit
main a b = do
  p <- a + b
  log "Point is" <> show p

-- main :: forall e. Eff (console :: CONSOLE | e) Unit
-- main = log "run"