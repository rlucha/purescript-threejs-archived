module Three.Camera where

import Prelude
import Three.Types (ThreeEff, Camera)

type Fov = Number
type Aspect = Number
type Near = Number
type Far = Number

type X = Number
type Y = Number
type Z = Number

foreign import create 
  :: Fov -> Aspect -> Near -> Far -> ThreeEff Camera

foreign import debug :: Camera -> ThreeEff Unit

foreign import setPosition 
  :: X -> Y -> Z -> Camera -> ThreeEff Unit

foreign import lookAt
  :: X -> Y -> Z -> Camera -> ThreeEff Unit

foreign import setAspect
  :: Number -> Camera -> ThreeEff Unit

foreign import updateProjectionMatrix 
  :: Camera -> ThreeEff Unit
