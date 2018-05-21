module Three.Materials.MeshPhongMaterial where

import Three.Types (ThreeEff, Material, Color)

foreign import createMeshPhongMaterial 
  :: Color
  -> ThreeEff Material 
