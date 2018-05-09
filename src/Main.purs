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
import Data.Int (toNumber)
-- import Math (cos, abs) as Math


import Time.Loop (makeLoop, Time)

import Three.Types (Three, ThreeT, Renderer, Scene, AxesHelper, Camera)
import Three (createColor, createAxesHelper)
import Three.Scene (debugScene, createScene, setSceneBackground, addToScene)
import Three.Renderer (createWebGLRenderer, setPixelRatio, setSize, mountRenderer, render)
import Three.Camera (createPerspectiveCamera)
import Three.OrbitControls (OrbitControls, createOrbitControls, enableControls, updateControls)

import Scenes.DotMatrix as DotMatrix

incT :: Time -> Number
incT n = toNumber(n + 1) 

showIntMil :: Int -> Int
showIntMil n = n + 1000

showTimesTwo :: Int -> Int
showTimesTwo n = n * 2

-- cosCalc :: Time -> Number
-- cosCalc t = Math.abs (Math.cos)
-- Math.abs(Math.cos((posX + posZ) * t * 0.00001) * 80)

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
  -- Compose this 3 fns below
  points <- DotMatrix.create 
  populatedScene <- addToScene points scene
  setSceneBackground color populatedScene

attachAxesHelper :: Scene -> Number -> ∀ e. Eff (three :: Three | e) Scene
attachAxesHelper scene size = do
  axesHelper <- createAxesHelper size
  addToScene axesHelper scene

createControls :: Camera -> Scene -> ∀ e. Eff (three :: Three | e) OrbitControls  
createControls camera scene = do 
  controls <- createOrbitControls camera
  enableControls controls 

renderScene :: forall e. Time -> Scene -> Camera -> Renderer -> Eff (three :: Three | e) Unit
renderScene t s c r = do
  -- scene <- s.update t
  render s c r
-- the whole doLoop function should be doing a lot of stuff by default
-- without us having to pass render or updatecontrol stuff
-- basically we should declare module effects and doloop should pick those up
-- and merge them with the default ones...
-- TODO Provide an interface to run loop with just the custom things
doLoop :: ∀ e. OrbitControls -> Scene -> Camera -> Renderer -> Eff (three :: Three, console :: CONSOLE | e) Unit
doLoop controls scene camera renderer = makeLoop
  -- Caculations (should be partially applied to be useful to the scene!)
    [ id <<< toNumber
    , incT ]
  -- Time bound effects
    [log <<< show
    -- , updateScene scene
    ]
  -- Time free effects
    [ updateControls controls
    , render scene camera renderer]
    0
-- T.createScene $ DotMatrix.scene

main :: ∀ e. Eff (three :: Three, console :: CONSOLE | e) Unit
main = do
  scene <- initScene
  camera <- createPerspectiveCamera 100.0 2.0 1.0 10000.0
  renderer <- createRenderer
  controls <- createControls camera scene
  -- Utils
  _ <- attachAxesHelper scene 100.0
  _ <- debugScene scene 
  mountRenderer renderer
  -- Main loop
  doLoop controls scene camera renderer
