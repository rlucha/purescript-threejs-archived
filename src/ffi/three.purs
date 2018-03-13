module Three where

import Prelude
import Point (Point)
import Control.Monad.Eff (Eff, kind Effect)

foreign import data Three :: Effect

foreign import createScene :: forall e. Array Point -> Eff (three :: Three | e)  Unit