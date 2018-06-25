module Three.Renderer where

import Prelude (Unit)
import Three.Types (Renderer, Scene, Camera)
import Effect

foreign import createWebGLRenderer :: Effect Renderer
foreign import setPixelRatio :: Renderer -> Effect Unit
foreign import setSize :: Number -> Number -> Renderer -> Effect Unit
foreign import mount :: Renderer -> Effect Unit
foreign import render :: Scene -> Camera -> Renderer -> Effect Unit
