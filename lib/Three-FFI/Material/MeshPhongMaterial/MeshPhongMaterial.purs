module Three.Materials.MeshPhongMaterial where

import Three.Types (ThreeEff, Material, Color)

type Lights = Boolean

foreign import createMeshPhongMaterial 
  :: Color
  -> Lights
  -> ThreeEff Material 
