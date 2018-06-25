module Three.Geometry.BoxGeometry where

import Effect
import Three.Types (Geometry)

type Width = Number
type Height = Number
type Depth = Number

-- Type these numbers to get some docs
foreign import create 
  :: Width 
  -> Height 
  -> Depth 
  -> Effect Geometry
