module Three.Materials.MeshPhongMaterial where

import Effect
import Three.Types (Material, Color)

type Lights = Boolean

foreign import create 
  :: Color
  -> Lights
  -> Effect Material 
