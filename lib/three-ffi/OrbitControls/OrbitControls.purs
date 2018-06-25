module Three.OrbitControls where

import Prelude (Unit)
import Three.Types (Camera)
import Effect

foreign import data OrbitControls :: Type

foreign import create :: Camera -> Effect OrbitControls
foreign import toggle :: Boolean -> OrbitControls -> Effect Unit
foreign import setAutoRotate :: Boolean -> OrbitControls -> Effect Unit
foreign import update :: OrbitControls -> Effect Unit
