module Projects.FrameBound.MapLoader where

import Effect

foreign import loadMap :: Effect String
