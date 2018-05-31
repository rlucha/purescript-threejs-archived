module Three.Object3D.Mesh where

import Prelude
import Three.Types (Geometry, Material, Object3D(Mesh), Object3D_, ThreeEff)

foreign import create_ :: Geometry -> Material -> ThreeEff Object3D_

create :: Geometry -> Material -> ThreeEff Object3D
create g m = do
  m' <- create_ g m
  pure $ Mesh m' 
