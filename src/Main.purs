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
import Three.Types (Three, ThreeT, Renderer, Scene, AxesHelper, Camera)
import Three (createColor, createAxesHelper)
import Three.Scene (debugScene, createScene, setSceneBackground, addToScene)
import Three.Renderer (createWebGLRenderer, setPixelRatio, setSize, mountRenderer, render)
import Three.Camera (createPerspectiveCamera)
import Time.Loop (makeLoop, LoopEff(..))
import Three.OrbitControls (OrbitControls, createOrbitControls, enableControls, updateControls)

showInt :: Int -> Int
showInt n = n + 1

showIntMil :: Int -> Int
showIntMil n = n + 1000

showTimesTwo :: Int -> Int
showTimesTwo n = n * 2

-- Why can't I use here ThreeT Renderer?
createRenderer :: ∀ e. Eff (three :: Three | e) Renderer
createRenderer = 
  createWebGLRenderer 
    >>= setPixelRatio -- Defaults to device ratio right now
    >>= setSize 1200.0 600.0 

initScene :: ThreeT Scene
initScene = do 
  scene <- createScene
  color <- createColor "#000000"
  setSceneBackground color scene

attachAxesHelper :: Scene -> Number -> ∀ e. Eff (three :: Three | e) Scene
attachAxesHelper scene size = do
  axesHelper <- createAxesHelper size
  addToScene axesHelper scene

-- how to constrain ThreeT to OrbitControls Specifically?
-- Now it is fully polymorphic...
createControls :: Camera -> Scene -> ∀ e. Eff (three :: Three | e) OrbitControls  
createControls camera scene = do 
  controls <- createOrbitControls camera
  enableControls controls 

main :: ∀ e. Eff (three :: Three, console :: CONSOLE | e) Unit
main = do
  scene <- initScene
  camera <- createPerspectiveCamera 100.0 2.0 1.0 1000.0
  renderer <- createRenderer
  controls <- createControls camera scene
  -- Utils
  _ <- attachAxesHelper scene 100.0
  _ <- debugScene scene 
  -- Render
  _ <- render scene camera renderer
  _ <- mountRenderer renderer
  -- Main Loop
  makeLoop [
      -- we are forced to have a function for Int to Eff
      -- that makes updateControls feel unnatural...
      LoopA (updateControls controls),
      LoopA $ render scene camera renderer,
    -- time loop
      LoopB showInt 
    -- showTimesTwo <<< showIntMil
  ] 0
-- T.createScene $ DotMatrix.scene
-- makeLoop needs to handle Eff...

-- TODO: Investigate, what is the relation between given a & b :: Eff e Unit
-- foo a b = do 
--   _ <- a
--   _ <- b
--   ....

-- foo a b = a *> b
