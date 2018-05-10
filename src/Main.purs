module Main where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Data.Int (toNumber)
import Data.Tuple (Tuple(..), fst)
import Data.Array (unsafeIndex)
import Partial.Unsafe (unsafePartial)
import Math (cos) as Math

import Time.Loop (makeLoop, Time)

import Three.Types (Camera, Renderer, Scene, Three, ThreeT)
import Three (createColor, createAxesHelper)
import Three.Scene (debugScene, createScene, setSceneBackground, addToScene)
import Three.Renderer (createWebGLRenderer, setPixelRatio, setSize, mountRenderer, render)
import Three.Camera (createPerspectiveCamera)
import Three.OrbitControls (OrbitControls, createOrbitControls, enableControls, updateControls)

import Scenes.DotMatrix  as DotMatrix

incT :: Time -> Number
incT n = toNumber(n + 1) / 100.0

cosT :: Time -> Number
cosT n = Math.cos(toNumber(n) * 0.01)

createRenderer :: ∀ e. Eff (three :: Three | e) Renderer
createRenderer = 
  createWebGLRenderer 
    >>= setPixelRatio -- Defaults to device ratio right now
    >>= setSize 1200.0 600.0

initScene :: ThreeT (Tuple Scene DotMatrix.AnimatedScene)
initScene = do 
  -- this createScene is the ThreeJS new Scene fn, not our actual scene representation
  -- find better naming to make them apart
  scene <- createScene
  color <- createColor "#000000"
  -- Compose this 3 fns below
  animatedScene <- DotMatrix.create
  let objects = DotMatrix.getSceneObjects animatedScene
  _ <- addToScene objects scene
  setSceneBackground color scene
  pure $ Tuple scene animatedScene

attachAxesHelper :: Scene -> Number -> ∀ e. Eff (three :: Three | e) Unit
attachAxesHelper scene size = do
  axesHelper <- createAxesHelper size
  addToScene axesHelper scene

createControls :: Camera -> Scene -> ∀ e. Eff (three :: Three | e) OrbitControls  
createControls camera scene = do 
  controls <- createOrbitControls camera
  enableControls controls 

updateScene :: forall e. DotMatrix.AnimatedScene -> Camera -> Renderer -> Array Number -> Eff (three :: Three | e) Unit
updateScene s c r t = do
-- Just while developing!! dangerous!
  DotMatrix.update s (unsafePartial $ unsafeIndex t 2)
-- the whole doLoop function should be doing a lot of stuff by default
-- without us having to pass render or updatecontrol stuff
-- basically we should declare module effects and doloop should pick those up
-- and merge them with the default ones...
-- TODO Provide an interface to run loop with just the custom things
doLoop :: ∀ e. OrbitControls -> Tuple Scene DotMatrix.AnimatedScene -> Camera -> Renderer -> Eff (three :: Three, console :: CONSOLE | e) Unit
doLoop controls (Tuple s as) camera renderer = makeLoop
  -- Caculations (should be partially applied to be useful to the scene!)
    [ id <<< toNumber
    , incT
    , cosT ]
  -- Time bound effects
    [log <<< show
    , updateScene as camera renderer
    ]
  -- Time free effects
    [ updateControls controls
    , render s camera renderer]
    0

main :: ∀ e. Eff (three :: Three, console :: CONSOLE | e) Unit
main = do
  scene <- initScene
  camera <- createPerspectiveCamera 100.0 2.0 1.0 10000.0
  renderer <- createRenderer
  controls <- createControls camera (fst scene)
  -- Utils
  _ <- attachAxesHelper (fst scene) 100.0
  _ <- debugScene (fst scene) 
  mountRenderer renderer
  -- Main loop
  doLoop controls scene camera renderer

-- TODO:
-- Change name of animatedScene to something that makes it apart por threejs scene
-- Make animatedScene a graph and provide a way to traverse it
-- Make results a record and provide a way to hook propery results animtedScene Update functions
-- Remove all partial unsafe functions
-- Make doLoop actually beautiful
-- Connect datGUI to those params to get some interactivity
-- Think about other UI for inputs
-- Next steps: Try to reproduce hierarchy2 example from threejs 
-- Create a set of JS utils to make IFF less painful
-- Get canvas size from window size
-- Change it on resize, updateMatrices
-- Remove Tuple Scene DotMatrix.AnimatedScene everywhere and treat them separatedly
-- Add Camera position set and camera lookAt fns
-- Create a draft of a type structure for threeJS (Object3D, Material, etc.)
-- Orbitcontrol rotate, autoupdate fns, enable zoom, etc.
-- Decide if effectful functions should return the object modified or just Unit...
-- Move updateVector3Position to PS, (make it change x y z?)
-- Make Time a newtype
-- Write a bit of documentation about the type decisions on Time.Loop and Main mostly
-- Remove most comments and create function names for those




