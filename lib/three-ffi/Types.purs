module Three.Types where

foreign import data Scene :: Type

foreign import data Renderer :: Type

foreign import data Camera :: Type

foreign import data Color :: Type

foreign import data Vector2 :: Type

foreign import data Vector3 :: Type

-- Core
foreign import data Geometry :: Type
-- Extras.Core
foreign import data Path :: Type
foreign import data Shape :: Type
 
-- Materials
foreign import data Material :: Type

-- Internal ThreeJS representation of Object3D
foreign import data Object3D_ :: Type

-- Objects
data Object3D = Mesh Object3D_
              | Points Object3D_
              | Light Object3D_

foreign import data AxesHelper :: Type