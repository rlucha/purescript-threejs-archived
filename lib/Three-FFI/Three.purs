module Three where

import Prelude
import Three.Types (Three, ThreeEff, Color, Geometry, Vector3, Object3D(..), Object3D_)
import Control.Monad.Eff (Eff, kind Effect)

foreign import createColor :: String -> ThreeEff Color
foreign import createAxesHelper :: Number -> ThreeEff Unit
foreign import createGeometry :: ThreeEff Geometry

foreign import createVector3 :: Number -> Number -> Number -> ThreeEff Vector3
foreign import pushVertices :: Geometry -> Vector3 -> ThreeEff Unit

foreign import updateVector3Position :: Number -> Number -> Number -> Vector3 -> ThreeEff Unit

foreign import getVector3Position 
  :: Vector3 
  -> ThreeEff { x :: Number, y :: Number, z :: Number }

-- TODO this is too specific and JS reliant
foreign import onDOMContentLoaded :: ∀ f e. f -> Eff (three :: Three | e) Unit

foreign import voidEff :: ThreeEff Unit
 
