module Three.Types where

import Control.Monad.Eff (Eff, kind Effect)

foreign import data Three :: Effect

foreign import data Scene :: Type

foreign import data Renderer :: Type

foreign import data Camera :: Type

foreign import data Color :: Type

foreign import data Vector3 :: Type

foreign import data Geometry :: Type
 
-- Materials
foreign import data Material :: Type

-- Internal ThreeJS representation of Object3D
foreign import data Object3D_ :: Type

-- Objects
data Object3D = Mesh Object3D_
              | Points Object3D_

foreign import data AxesHelper :: Type

-- Three Effect Constructor? bad naming maybe?
type ThreeEff t = ∀ e. Eff (three :: Three | e) t
