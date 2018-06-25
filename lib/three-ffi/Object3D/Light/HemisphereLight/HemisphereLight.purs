module Three.Object3D.Light.HemisphereLight where

import Prelude
import Effect
import Three.Types (Color, Object3D(Light), Object3D_)

type SkyColor = Color
type GroundColor = Color
type Intensity = Number

foreign import create_ :: SkyColor -> GroundColor -> Intensity -> Effect Object3D_

create :: SkyColor -> GroundColor -> Intensity -> Effect Object3D
create c1 c2 i = do
  l <- create_ c1 c2 i
  pure $ Light l
