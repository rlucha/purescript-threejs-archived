module Projects.FrameBound.MapLoader where

import Effect

foreign import loadBuildings :: Effect String
foreign import loadStreets :: Effect String
 