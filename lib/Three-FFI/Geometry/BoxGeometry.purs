module Three.Geometry.BoxGeometry where

import Three.Types (ThreeEff, Geometry)

-- Type these numbers to get some docs
foreign import createBoxGeometry 
  :: Number 
  -> Number 
  -> Number 
  -> ThreeEff Geometry
