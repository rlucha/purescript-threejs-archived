module Three where

import Prelude
import Three.Types (ThreeT, Color, Geometry, Vector3)
import Control.Monad.Eff (Eff, kind Effect)

foreign import createColor :: String -> ThreeT Color
foreign import createAxesHelper :: Number -> ThreeT Unit
foreign import createGeometry :: ThreeT Geometry

foreign import createVector3 :: Number -> Number -> Number -> ThreeT Vector3
foreign import pushVertices :: Geometry -> Vector3 -> ThreeT Geometry