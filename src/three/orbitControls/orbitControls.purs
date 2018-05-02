module Three.OrbitControls where

import Prelude (Unit)
import Three.Types (Three, ThreeT, Camera)
import Control.Monad.Eff (Eff)

foreign import data OrbitControls :: Type

foreign import createOrbitControls :: Camera -> ThreeT OrbitControls
foreign import enableControls :: OrbitControls -> ThreeT OrbitControls
foreign import updateControls :: OrbitControls -> ThreeT Unit
