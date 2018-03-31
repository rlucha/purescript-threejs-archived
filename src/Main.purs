module Main where

-- TODO 
-- get input from the JS side, scene would be a function with config params that returns an array of points
-- Connect datGUI to those params to get some interactivity
-- Think about other UI for inputs
-- Can we keep a reference to all created points so that only the positions change?
-- That way we could make the scene animated without perf decrease
-- Next steps: Try to reproduce hierarchy2 example from threejs 

import Prelude
import Control.Monad.Eff (Eff)
import Three (Three, createScene)  as T

-- Scenes
-- import Scenes.SimpleLine (scene) as SimpleLine
-- import Scenes.BoxOfPoints (scene) as BoxOfPoints
-- import Scenes.SceneAsFunction (scene) as SceneAsFunction

-- import Scenes.BoxToBox (scene) as BoxToBox
import Scenes.SquaresSurface (scene) as SquaresSurface

main :: forall e. Eff (three :: T.Three | e)  Unit
main = T.createScene $ SquaresSurface.scene