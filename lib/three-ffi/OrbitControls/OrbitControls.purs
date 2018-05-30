module Three.OrbitControls where

import Prelude (Unit)
import Three.Types (Camera, ThreeEff)

foreign import data OrbitControls :: Type

foreign import create :: Camera -> ThreeEff OrbitControls
foreign import toggle :: Boolean -> OrbitControls -> ThreeEff Unit
foreign import update :: OrbitControls -> ThreeEff Unit
