module Three.Object3D.Mesh where

import Prelude
import Effect
import Three.Types (Geometry, Material, Object3D(Mesh), Object3D_)

foreign import create_ :: Geometry -> Material -> Effect Object3D_

create :: Geometry -> Material -> Effect Object3D
create g m = do
  m' <- create_ g m
  pure $ Mesh m' 
