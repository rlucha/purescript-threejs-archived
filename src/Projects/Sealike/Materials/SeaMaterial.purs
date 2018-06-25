module Projects.Sealike.SeaMaterial where

import Effect
import Three.Types (Material)

foreign import createSeaMaterial :: Effect Material 
