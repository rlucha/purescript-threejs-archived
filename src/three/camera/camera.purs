module Three.Camera where

-- Maybe move the camera type into the camera module?
import Three.Types (ThreeT, Camera)

foreign import createPerspectiveCamera ::
  Number -> Number -> Number -> Number -> ThreeT Camera