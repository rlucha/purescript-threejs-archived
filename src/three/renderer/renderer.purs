module Three.Renderer where

import Prelude (Unit)
import Three.Types (Three, Renderer, Scene, Camera)
import Control.Monad.Eff (Eff)

foreign import createWebGLRenderer :: forall e. Eff (three :: Three | e) Renderer
foreign import setPixelRatio :: forall e. Renderer -> Eff (three :: Three | e) Renderer
foreign import setSize :: forall e. Number -> Number -> Renderer -> Eff (three :: Three | e) Renderer
foreign import mountRenderer :: forall e. Renderer -> Eff (three :: Three | e) Unit
foreign import render :: forall e. Scene -> Camera -> Renderer -> Eff (three :: Three | e) Renderer