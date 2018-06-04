module Three.Extras.Core.Shape where

import Prelude

import Three.Types (ThreeEff, Vector2, Shape)

foreign import create 
  :: Array Vector2 -> ThreeEff Shape
