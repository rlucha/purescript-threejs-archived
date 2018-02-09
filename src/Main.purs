module Main where

-- TODO 
-- get input from the JS side, scene would be a function with config params that returns an array of points
-- Connect datGUI to those params to get some interactivity
-- Think about other UI for inputs

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Foreign.Class (class Encode, encode)
import Data.Foreign.Generic (defaultOptions, genericEncodeJSON)

import Point
import Line (interpolateLine)
import Scene (Scene(..))

import Scenes.BoxOfPoints (scene) as BoxOfPoints
import Scenes.SimpleLine (scene) as SimpleLine

-- import Control.Monad.Eff (Eff)
-- import Control.Monad.Eff.Console (CONSOLE, log)

-- Prepare encoding
sceneJSON = genericEncodeJSON (defaultOptions { unwrapSingleConstructors = true }) BoxOfPoints.scene