module Three.Extras.Core.Shape where

import Prelude

import Effect
import Three.Types (Vector2, Shape)

foreign import create 
  :: Array Vector2 -> Effect Shape
