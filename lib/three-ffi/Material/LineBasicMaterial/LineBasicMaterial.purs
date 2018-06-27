module Three.Materials.LineBasicMaterial where

import Effect
import Three.Types (Material, Color)

foreign import create 
  :: Color
  -> Effect Material 
