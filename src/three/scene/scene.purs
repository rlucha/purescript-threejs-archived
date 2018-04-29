module Three.Scene where

import Three.Types (Three, Scene)
import Control.Monad.Eff (Eff)

foreign import createScene :: forall e. Eff (three :: Three | e) Scene