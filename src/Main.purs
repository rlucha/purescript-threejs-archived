module Main where

-- TODO 
-- get input from the JS side, scene would be a function with config params that returns an array of points
-- Connect datGUI to those params to get some interactivity
-- Think about other UI for inputs
-- Can we keep a reference to all created points so that only the positions change?
-- That way we could make the scene animated without perf decrease
-- Next steps: Try to reproduce hierarchy2 example from threejs 

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Foreign.Class (class Encode, encode)
import Data.Foreign.Generic (defaultOptions, genericEncodeJSON)

import Three as Three
import Point
import Line (interpolateLine)
import Scene as S

-- Scenes
import Scenes.SimpleLine (scene) as SimpleLine
import Scenes.BoxOfPoints (scene) as BoxOfPoints
import Scenes.BoxToBox (scene) as BoxToBox
import Scenes.SceneAsFunction (scene) as SceneAsFunction

-- import Control.Monad.Eff (Eff)
-- import Control.Monad.Eff.Console (CONSOLE, log)

-- Prepare encoding
-- sceneJSON :: String
-- sceneJSON = genericEncodeJSON (defaultOptions { unwrapSingleConstructors = true }) BoxToBox.scene

-- makeScene :: Number -> String
-- makeScene t = genericEncodeJSON (defaultOptions { unwrapSingleConstructors = true }) $ BoxToBox.scene t

main = Three.createScene $ S.unfoldScene $ BoxToBox.scene 5.0