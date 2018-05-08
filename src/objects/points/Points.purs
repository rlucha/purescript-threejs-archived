module Three.Objects.Points where

import Three.Types (ThreeT, Point, Geometry, Material)

foreign import createPoints :: Geometry -> Material -> ThreeT Point