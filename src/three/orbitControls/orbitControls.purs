module Three.OrbitControls where

import Prelude (Unit)
import Three.Types (ThreeT, Camera)

foreign import data OrbitControls :: Type

foreign import createOrbitControls :: Camera -> ThreeT OrbitControls
foreign import enableControls :: OrbitControls -> ThreeT OrbitControls
foreign import updateControls :: OrbitControls -> ThreeT Unit
