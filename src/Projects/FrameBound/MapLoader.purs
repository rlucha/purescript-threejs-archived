module Projects.FrameBound.MapLoader where

import Control.Monad.Eff (Eff)

foreign import loadMap :: ∀ e. (Eff e) String
