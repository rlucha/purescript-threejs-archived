module Three.Object3D where

import Effect
import Prelude

import Three (getVector3Position)
import Three.Camera (setPosition)
-- TODO explain the need of Object3D and Object3D_
import Three.Types (Object3D(..), Object3D_, Vector3)

-- Can we reduce some boilerplate? this functions are doing the same thing all over...

foreign import setPosition_ :: Number -> Number -> Number -> Object3D_ -> Effect Unit
foreign import getPosition_ :: Object3D_ -> Effect Vector3
foreign import setRotation_ :: Number -> Number -> Number -> Object3D_ -> Effect Unit
foreign import setScale_ :: Number -> Number -> Number -> Object3D_ -> Effect Unit
foreign import rotateOnAxis_ :: Vector3 -> Number -> Object3D_ -> Effect Unit
foreign import forceVerticesUpdate_ :: Object3D_ -> Effect Unit
foreign import setReceiveShadow_ :: Boolean -> Object3D_ -> Effect Unit
foreign import setCastShadow_ :: Boolean -> Object3D_ -> Effect Unit
 
-- Using functor on Object3D
-- setPosition :: Number -> Number -> Number -> Object3D -> Effect Unit
-- setPosition x y z o = traverse_ (setPosition_ x y z) o

setPosition :: Number -> Number -> Number -> Object3D -> Effect Unit
setPosition x y z o = setPosition_ x y z (unwrap o)

setRotation :: Number -> Number -> Number -> Object3D -> Effect Unit
setRotation x y z o = setRotation_ x y z (unwrap o)

setScale :: Number -> Number -> Number -> Object3D -> Effect Unit
setScale x y z o = setScale_ x y z (unwrap o)

rotateOnAxis :: Vector3 -> Number -> Object3D -> Effect Unit
rotateOnAxis v3 angle o = rotateOnAxis_ v3 angle (unwrap o)

forceVerticesUpdate :: Object3D -> Effect Unit
forceVerticesUpdate o = forceVerticesUpdate_ (unwrap o)

getPosition :: Object3D -> Effect { x :: Number, y :: Number, z :: Number }
getPosition o = getPosition_ (unwrap o) >>= getVector3Position

-- make Object3D functor so we can map on it no matter the value?
setReceiveShadow :: Boolean -> Object3D -> Effect Unit
setReceiveShadow b o = setReceiveShadow_ b (unwrap o)

setCastShadow :: Boolean -> Object3D -> Effect Unit
setCastShadow b o = setCastShadow_ b (unwrap o)

-- This is completely redundant
unwrap :: Object3D -> Object3D_
unwrap (Object3D o) = o.unObject3D
