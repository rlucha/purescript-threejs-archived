module Three.Geometry.ExtrudeGeometry where

import Three.Types (Geometry, Shape, ThreeEff)

type Depth = Number

-- Type these numbers to get some docs
foreign import create 
  :: Depth
  -> Shape
  -> ThreeEff Geometry
