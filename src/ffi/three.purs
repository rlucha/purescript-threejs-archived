module Three where

import Prelude
import Point (Point)
import Scene
import Control.Monad.Eff (Eff, kind Effect)

foreign import data Three :: Effect

foreign import createScene :: forall e. Scene -> Eff (three :: Three | e)  Unit 