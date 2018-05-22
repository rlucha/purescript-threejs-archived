module Three.Materials.MeshPhongMaterial where

import Three.Types (ThreeEff, Material, Color)

type Lights = Boolean

foreign import create 
  :: Color
  -> Lights
  -> ThreeEff Material 
