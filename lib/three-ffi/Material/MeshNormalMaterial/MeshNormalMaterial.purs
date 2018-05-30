module Three.Materials.MeshNormalMaterial where

import Three.Types (ThreeEff, Material, Color)

foreign import create 
  :: Color
  -> Boolean
  -> ThreeEff Material
