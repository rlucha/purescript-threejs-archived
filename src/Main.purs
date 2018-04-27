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
import Control.Monad.Eff.Console (CONSOLE, log)
import Three (Three, createScene)  as T
import Time.Loop (initLoop)

-- Scenes
import Scenes.DotMatrix (scene) as DotMatrix

main :: forall e. Eff (three :: T.Three, console :: CONSOLE | e)  Unit
main = do
  T.createScene $ DotMatrix.scene
  initLoop
  
