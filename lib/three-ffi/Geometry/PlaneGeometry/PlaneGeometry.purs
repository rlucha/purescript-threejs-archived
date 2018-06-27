module Three.Geometry.PlaneGeometry where

import Effect
import Three.Types (Geometry, Shape)

type Width = Number
type Height = Number
type WidthSegments = Int
type HeightSegments = Int

foreign import create 
  :: Width
  -> Height
  -> WidthSegments
  -> HeightSegments
  -> Effect Geometry
