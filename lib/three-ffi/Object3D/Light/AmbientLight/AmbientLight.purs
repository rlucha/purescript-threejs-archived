module Three.Object3D.Light.AmbientLight where

import Prelude
import Effect
import Three.Types (Object3D(..), Object3DTag(..), Object3D_, Color, Geometry, Material)

type Intensity = Number

foreign import create_ :: Color -> Intensity -> Effect Object3D_

create :: Color -> Intensity -> Effect Object3D
create c i = do
  l <- create_ c i
  pure $ Object3D { unObject3D: l, tag: Light }
