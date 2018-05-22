module Three.Geometry.BoxGeometry where

import Three.Types (ThreeEff, Geometry)

type Width = Number
type Height = Number
type Depth = Number

-- Type these numbers to get some docs
foreign import create 
  :: Width 
  -> Height 
  -> Depth 
  -> ThreeEff Geometry
