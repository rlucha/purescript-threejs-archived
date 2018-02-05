module Main where

import Point
import Prelude

import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Foreign.Class (class Encode, encode)
import Data.Foreign.Generic (defaultOptions, genericEncodeJSON)

import Data.List (List, toUnfoldable)
import Line (interpolateLine)

-- import Control.Monad.Eff (Eff)
-- import Control.Monad.Eff.Console (CONSOLE, log)

data Scene = Scene (Array Point)
derive instance genScene :: Generic Scene _
instance showScene :: Show Scene where show = genericShow

a = Point {x: 0.0, y: 0.0}

b = Point {x: 10.0, y: 5.0}

c = interpolateLine a b 10

scene = Scene (toUnfoldable c)

-- Prepare encoding
sceneJSON = genericEncodeJSON (defaultOptions { unwrapSingleConstructors = true }) scene

-- main :: forall e. Eff (console :: CONSOLE | e) Unit
-- main = do
--   let scene =  Scene c
--   log (show scene)

