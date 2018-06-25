module Three.Object3D.Points where

import Prelude
import Effect
import Three.Types (Object3D(Points), Object3D_, Geometry, Material)

foreign import create_ :: Geometry -> Material -> Effect Object3D_

create :: Geometry -> Material -> Effect Object3D
create g m = do
  m' <- create_ g m
  pure $ Points m' 
