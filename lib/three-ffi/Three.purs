module Three where

import Prelude
import Effect
import Three.Types (Color, Geometry, Vector2, Vector3)

foreign import createColor :: String -> Effect Color
foreign import createAxesHelper :: Number -> Effect Unit
foreign import createGeometry :: Effect Geometry

foreign import createVector2 :: Number -> Number -> Effect Vector2
foreign import createVector3 :: Number -> Number -> Number -> Effect Vector3
foreign import pushVertices :: Geometry -> Vector3 -> Effect Unit

foreign import updateVector3Position :: Number -> Number -> Number -> Vector3 -> Effect Unit

foreign import getVector3Position 
  :: Vector3 
  -> Effect { x :: Number, y :: Number, z :: Number }

-- TODO this is too specific and JS reliant
foreign import onDOMContentLoaded :: Effect Unit
foreign import onResize :: Effect Unit

foreign import voidEff :: Effect Unit
 
