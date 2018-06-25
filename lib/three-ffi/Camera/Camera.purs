module Three.Camera where

import Prelude
import Effect
import Three.Types (Camera)

type Fov = Number
type Aspect = Number
type Near = Number
type Far = Number

type X = Number
type Y = Number
type Z = Number

foreign import create 
  :: Fov -> Aspect -> Near -> Far -> Effect Camera

foreign import debug :: Camera -> Effect Unit

-- TODO Use Object3D setPoasition instead
foreign import setPosition 
  :: X -> Y -> Z -> Camera -> Effect Unit

foreign import lookAt
  :: X -> Y -> Z -> Camera -> Effect Unit

foreign import setAspect
  :: Number -> Camera -> Effect Unit

foreign import updateProjectionMatrix 
  :: Camera -> Effect Unit
