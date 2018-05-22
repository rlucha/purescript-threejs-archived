module Three.Scene where

import Prelude (Unit)
import Three.Types (Color, Scene, ThreeEff)

type SceneEff = ThreeEff Scene

foreign import create :: SceneEff

-- Do not return Scene on any of this side effectful functions
foreign import setBackground :: Color -> Scene -> ThreeEff Unit
foreign import add :: ∀ t. Scene -> t -> ThreeEff Unit
foreign import debug :: Scene -> ThreeEff Unit
