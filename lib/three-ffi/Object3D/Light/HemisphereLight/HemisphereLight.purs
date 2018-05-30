module Three.Object3D.Light.HemisphereLight where

import Prelude
import Three.Types (ThreeEff, Color, Object3D(Light), Object3D_)

type Intensity = Number
type SkyColor = Color
type GroundColor = Color

foreign import create_ :: SkyColor -> GroundColor -> Intensity -> ThreeEff Object3D_

create :: SkyColor -> GroundColor -> Intensity -> ThreeEff Object3D
create c1 c2 i = do
  l <- create_ c1 c2 i
  pure $ Light l
