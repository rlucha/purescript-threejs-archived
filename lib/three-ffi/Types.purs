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

foreign import data AxesHelper :: Type

-- Objects (Amar recommendation)
-- Here we lose the reference to Object3D_
-- data ObjectType = Mesh | Points | Light | Line

-- Making Object3D polymorphic allows us to create instaces for it
-- but making it completely polymorphic loses some safety
-- data Object3D a = Object
--   { objectType :: ObjectType
--   , object :: a
--   }

-- instance Functor Object3D where
--   map f (Object3D t a) = Object3D t (f a)

-- from chexxor #purescript-beginners
data Object3DTag = Mesh | Points | Light | Line
newtype Object3D = Object3D
  { unObject3D :: Object3D_
  , tag :: Object3DTag 
  }
-- setPosition :: forall e. Number -> Number -> Number -> { o :: Object3D_ | e }

