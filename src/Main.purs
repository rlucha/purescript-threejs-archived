module Main where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)

import Point
import Line

main :: forall e. Eff (console :: CONSOLE | e) Unit
main = do
  let x =  add (Point {x:3.0, y:2.5}) (Point {x:3.0, y:2.5})
  log (show x)