module Three.Materials.MeshNormalMaterial where

import Effect
import Three.Types (Material, Color)

foreign import create 
  :: Color
  -> Boolean
  -> Effect Material
