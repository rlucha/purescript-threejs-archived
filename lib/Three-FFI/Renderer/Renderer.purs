module Three.Renderer where

import Prelude (Unit)
import Three.Types (ThreeEff, Renderer, Scene, Camera)

foreign import createWebGLRenderer :: ∀ e. ThreeEff Renderer
foreign import setPixelRatio :: ∀ e. Renderer -> ThreeEff Unit
foreign import setSize :: ∀ e. Number -> Number -> Renderer -> ThreeEff Unit
foreign import mountRenderer :: ∀ e. Renderer -> ThreeEff Unit
foreign import render :: ∀ e. Scene -> Camera -> Renderer -> ThreeEff Unit