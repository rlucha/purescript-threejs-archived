module Three.Object3D.Points where

import Three.Types (ThreeEff, Object3D, Geometry, Material)

foreign import create :: Geometry -> Material -> ThreeEff Object3D
