module Three.Camera where

-- Maybe move the camera type into the camera module?
import Three.Types (ThreeEff, Camera)

type Fov = Number
type Aspect = Number
type Near = Number
type Far = Number

foreign import createPerspectiveCamera ::
  Fov -> Aspect -> Near -> Far -> ThreeEff Camera