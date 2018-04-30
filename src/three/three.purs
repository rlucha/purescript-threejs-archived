module Three where

import Prelude
import Scene
import Three.Types (ThreeT, Color)
import Control.Monad.Eff (Eff, kind Effect)

foreign import createColor :: String -> ThreeT Color