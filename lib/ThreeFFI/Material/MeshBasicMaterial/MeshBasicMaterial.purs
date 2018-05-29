module Three.Materials.MeshBasicMaterial where

import Three.Types (ThreeEff, Material, Color)

foreign import create 
  :: Color
  -> ThreeEff Material 
