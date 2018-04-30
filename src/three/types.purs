module Three.Types where

import Control.Monad.Eff (Eff, kind Effect)

foreign import data Three :: Effect

foreign import data Scene :: Type

foreign import data Renderer :: Type

foreign import data Camera :: Type

foreign import data Color :: Type

foreign import data AxesHelper :: Type

-- Three Effect Constructor? bad naming maybe?
type ThreeT t = forall e t. Eff (three :: Three | e) t