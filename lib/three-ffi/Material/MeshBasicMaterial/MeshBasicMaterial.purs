module Three.Materials.MeshBasicMaterial where

import Effect
import Three.Types (Material, Color)

foreign import create 
  :: Color
  -> Effect Material 
