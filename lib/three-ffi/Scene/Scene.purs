module Three.Scene where

import Prelude (Unit)
import Three.Types (Color, Scene)
import Effect

foreign import create :: Effect Scene

-- Do not return Scene on any of this side effectful functions
foreign import setBackground :: Color -> Scene -> Effect Unit
foreign import add :: ∀ t. Scene -> t -> Effect Unit
foreign import debug :: Scene -> Effect Unit
