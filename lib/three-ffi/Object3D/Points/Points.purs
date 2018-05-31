module Three.Object3D.Points where

import Prelude
import Three.Types (ThreeEff, Object3D(Points), Object3D_, Geometry, Material)

foreign import create_ :: Geometry -> Material -> ThreeEff Object3D_

create :: Geometry -> Material -> ThreeEff Object3D
create g m = do
  m' <- create_ g m
  pure $ Points m' 
