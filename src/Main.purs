module Main where

-- TODO 
-- get input from the JS side, scene would be a function with config params that returns an array of points
-- Connect datGUI to those params to get some interactivity
-- Think about other UI for inputs
-- Can we keep a reference to all created points so that only the positions change?
-- That way we could make the scene animated without perf decrease
-- Next steps: Try to reproduce hierarchy2 example from threejs 

import Prelude
import Control.Extend ((<<=))
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Three.Types (Three, Renderer, Scene, Color)
import Three (createColor)
import Three.Scene (createScene, setSceneBackground)
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
createRenderer = 
  createWebGLRenderer 
    >>= setPixelRatio 
    >>= setSize 100.0 100.0 
    >>= mountRenderer

initScene :: forall e. Eff (three :: Three | e) Scene
initScene = do
  scene <- createScene
  color <- createColor "0xfff"
  setSceneBackground scene color

main :: forall e. Eff (three :: Three, console :: CONSOLE | e)  Unit
main = do
  -- T.createScene $ DotMatrix.scene
  createRenderer
  makeLoop [showInt, showTimesTwo <<< showIntMil] 0
  
