module Three.Object3D where

import Prelude
import Three (getVector3Position)
import Three.Types (ThreeEff, Object3D(..), Object3D_, Vector3)

foreign import setPosition_ :: Number -> Number -> Number -> Object3D_ -> ThreeEff Unit

setPosition :: Number -> Number -> Number -> Object3D -> ThreeEff Unit
setPosition x y z o = case o of
  Mesh o' -> setPosition_ x y z o'
  -- Fix points position setting
  Points o' -> setPosition_ x y z o'

unwrapObject3D :: Object3D -> Object3D_
unwrapObject3D o = case o of
    Points o' -> o' 
    Mesh o' -> o'

foreign import forceVerticesUpdate_ :: Object3D_ -> ThreeEff Unit

forceVerticesUpdate :: Object3D -> ThreeEff Unit
forceVerticesUpdate o = do
  let o' = unwrapObject3D o
  forceVerticesUpdate_ o'

foreign import getPosition_ :: Object3D_ -> ThreeEff Vector3

getPosition :: Object3D -> ThreeEff { x :: Number, y :: Number, z :: Number }
getPosition o = case o of
-- can we replace this for getPosition_ unwrap o >>= ???
  Mesh o' -> getPosition_ o' >>= getVector3Position
  Points o' -> getPosition_ o' >>= getVector3Position
