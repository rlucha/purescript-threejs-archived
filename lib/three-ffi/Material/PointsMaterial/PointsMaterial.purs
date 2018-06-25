module Three.Materials.PointsMaterial where

import Effect 
import Three.Types (Material)

foreign import create :: 
  Effect Material 
