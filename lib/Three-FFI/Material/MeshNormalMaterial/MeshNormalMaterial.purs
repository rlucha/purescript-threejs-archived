module Three.Materials.MeshNormalMaterial where

import Three.Types (ThreeEff, Material, Color)

foreign import createMeshNormalMaterial 
  :: Color
  -> Boolean
  -> ThreeEff Material
