module Three.Types where

import Control.Monad.Eff (kind Effect)

foreign import data Three :: Effect
foreign import data Scene :: Type
foreign import data Renderer :: Type