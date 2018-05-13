module Three.Objects.Points where

import Three.Types (ThreeEff, Points, Geometry, Material)

foreign import createPoints :: Geometry -> Material -> ThreeEff Points