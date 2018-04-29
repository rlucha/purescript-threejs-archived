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
import Three.Types (Three, Renderer)
import Three.Scene (createScene)
import Three.Renderer (createWebGLRenderer, setPixelRatio, setSize, mountRenderer)
import Time.Loop (makeLoop)
-- Scenes
import Scenes.DotMatrix (scene) as DotMatrix


showInt :: forall e. Int -> Int
showInt n = n + 1

showIntMil :: forall e. Int -> Int
showIntMil n = n + 1000

showTimesTwo :: Int -> Int
showTimesTwo n = n * 2

createRenderer :: forall e. Eff (three :: Three | e) Unit
createRenderer = do 
  r0 <- createWebGLRenderer
  r1 <- setPixelRatio r0
  r2 <- setSize r1 100.0 100.0
  mountRenderer r1

main :: forall e. Eff (three :: Three, console :: CONSOLE | e)  Unit
main = do
  -- T.createScene $ DotMatrix.scene
  createRenderer
  makeLoop [showInt, showTimesTwo <<< showIntMil] 0
  
