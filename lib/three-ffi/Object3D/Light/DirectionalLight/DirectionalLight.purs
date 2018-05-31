module Three.Object3D.Light.DirectionalLight where

import Prelude
import Three.Types (ThreeEff, Color, Object3D(Light), Object3D_)

type Intensity = Number

foreign import create_ :: Color -> Intensity -> ThreeEff Object3D_

create :: Color -> Intensity -> ThreeEff Object3D
create c i = do
  l <- create_ c i
  pure $ Light l
