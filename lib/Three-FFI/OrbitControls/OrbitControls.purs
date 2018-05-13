module Three.OrbitControls where

import Prelude (Unit)
import Three.Types (Camera, ThreeEff)

foreign import data OrbitControls :: Type

foreign import createOrbitControls :: Camera -> ThreeEff OrbitControls
foreign import enableControls :: OrbitControls -> ThreeEff Unit
foreign import updateControls :: OrbitControls -> ThreeEff Unit