module Three.Objects.Points where

import Three.Types (ThreeT, Points, Geometry, Material)

foreign import createPoints :: Geometry -> Material -> ThreeT Points