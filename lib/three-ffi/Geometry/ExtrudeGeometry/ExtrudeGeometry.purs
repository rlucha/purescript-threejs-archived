module Three.Geometry.ExtrudeGeometry where

import Effect
import Three.Types (Geometry, Shape)

type Depth = Number

-- Type these numbers to get some docs
foreign import create 
  :: Depth
  -> Shape
  -> Effect Geometry
