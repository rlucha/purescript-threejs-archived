module Three.Scene where

import Three.Types (Three, ThreeT, Color, Scene)
import Control.Monad.Eff (Eff)

-- type SceneEff = ∀ e. Eff (three :: Three | e) Scene
-- foreign import createScene :: SceneEff

type SceneEff = ThreeT Scene

foreign import createScene :: SceneEff

foreign import setSceneBackground :: Color -> Scene -> SceneEff
foreign import addToScene :: ∀ t. t -> Scene -> SceneEff
foreign import debugScene :: Scene -> SceneEff