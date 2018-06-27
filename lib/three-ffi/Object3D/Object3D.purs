module Three.Object3D where

import Prelude
import Effect
import Three (getVector3Position)
import Three.Types (Object3D(..), Object3D_, Vector3)

foreign import setPosition_ :: Number -> Number -> Number -> Object3D_ -> Effect Unit
foreign import getPosition_ :: Object3D_ -> Effect Vector3
foreign import setRotation_ :: Number -> Number -> Number -> Object3D_ -> Effect Unit
foreign import forceVerticesUpdate_ :: Object3D_ -> Effect Unit
foreign import setReceiveShadow_ :: Boolean -> Object3D_ -> Effect Unit
foreign import setCastShadow_ :: Boolean -> Object3D_ -> Effect Unit

setPosition :: Number -> Number -> Number -> Object3D -> Effect Unit
setPosition x y z o = case o of
  Mesh o' -> setPosition_ x y z o'
  -- Fix points position setting
  Points o' -> setPosition_ x y z o'
  Light o' -> setPosition_ x y z o'
  Line o' -> setPosition_ x y z o'

setRotation :: Number -> Number -> Number -> Object3D -> Effect Unit
setRotation x y z o = case o of
  Mesh o' -> setRotation_ x y z o'
  -- Fix points position setting
  Points o' -> setRotation_ x y z o'
  Light o' -> setRotation_ x y z o'
  Line o' -> setRotation_ x y z o'

unwrap :: Object3D -> Object3D_
unwrap o = case o of
  Points o' -> o' 
  Mesh o' -> o'
  Light o' -> o'
  Line o' -> o'

forceVerticesUpdate :: Object3D -> Effect Unit
forceVerticesUpdate o = do
  let o' = unwrap o
  forceVerticesUpdate_ o'

getPosition :: Object3D -> Effect { x :: Number, y :: Number, z :: Number }
getPosition o = case o of
-- can we replace this for getPosition_ unwrap o >>= ???
  Mesh o' -> getPosition_ o' >>= getVector3Position
  Points o' -> getPosition_ o' >>= getVector3Position
  Light o' -> getPosition_ o' >>= getVector3Position
  Line o' -> getPosition_ o' >>= getVector3Position

-- Do this with unwrap, right?
-- make Object3D functor so we can map on it no matter the value?
setReceiveShadow :: Boolean -> Object3D -> Effect Unit
setReceiveShadow b o = case o of 
  Mesh o' -> setReceiveShadow_ b o'
  Points o' -> setReceiveShadow_ b o'
  Light o' -> setReceiveShadow_ b o'
  Line o' -> setReceiveShadow_ b o'

setCastShadow :: Boolean -> Object3D -> Effect Unit
setCastShadow b o = case o of 
  Mesh o' -> setCastShadow_ b o'
  Points o' -> setCastShadow_ b o'
  Light o' -> setCastShadow_ b o'
  Line o' -> setCastShadow_ b o'
