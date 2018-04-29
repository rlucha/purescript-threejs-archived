module Three.Renderer where

import Prelude (Unit)
import Three.Types (Three, Renderer)
import Control.Monad.Eff (Eff)

foreign import createWebGLRenderer :: forall e. Eff (three :: Three | e) Renderer
foreign import setPixelRatio :: forall e. Renderer -> Eff (three :: Three | e) Renderer
foreign import setSize :: forall e. Renderer -> Number -> Number -> Eff (three :: Three | e) Renderer
foreign import mountRenderer :: forall e. Renderer -> Eff (three :: Three | e) Unit