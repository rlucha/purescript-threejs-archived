module Three.Scene where

import Prelude (Unit)
import Three.Types (Three, ThreeT, Color, Scene)
import Control.Monad.Eff (Eff)

-- type SceneEff = ∀ e. Eff (three :: Three | e) Scene
-- foreign import createScene :: SceneEff

type SceneEff = ThreeT Scene

foreign import createScene :: SceneEff

foreign import setSceneBackground :: Color -> Scene -> ThreeT Unit
foreign import addToScene :: ∀ t. t -> Scene -> ThreeT Unit
foreign import debugScene :: Scene -> ThreeT Unit