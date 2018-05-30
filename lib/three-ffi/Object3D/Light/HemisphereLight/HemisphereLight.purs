module Three.Object3D.Light.HemisphereLight where

import Prelude
import Three.Types (ThreeEff, Color, Object3D(Light), Object3D_)

foreign import create_ :: Color -> ThreeEff Object3D_

create :: Color -> ThreeEff Object3D
create c = do
  l <- create_ c
  pure $ Light l
