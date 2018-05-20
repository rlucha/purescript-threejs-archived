module Three.Scene where

import Prelude (Unit)
import Three.Types (Color, Scene, ThreeEff)

type SceneEff = ThreeEff Scene

foreign import createScene :: SceneEff

-- Do not return Scene on any of this side effectful functions
foreign import setSceneBackground :: Color -> Scene -> ThreeEff Unit
foreign import addToScene :: ∀ t. Scene -> t -> ThreeEff Unit
foreign import debugScene :: Scene -> ThreeEff Unit
