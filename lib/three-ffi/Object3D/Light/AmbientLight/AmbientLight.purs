module Three.Object3D.Light.AmbientLight where

import Prelude
import Effect
import Three.Types (Color, Object3D(Light), Object3D_)

type Intensity = Number

foreign import create_ :: Color -> Intensity -> Effect Object3D_

create :: Color -> Intensity -> Effect Object3D
create c i = do
  l <- create_ c i
  pure $ Light l
