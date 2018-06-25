module Projects.FrameBound.Types where

import Prelude

import Foreign.Class (class Decode)
import Foreign.Generic (defaultOptions, genericDecode)

import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Newtype (class Newtype)

opts = defaultOptions { unwrapSingleConstructors = true }

newtype Coords = Coords { x :: Number, y :: Number, z :: Number }
derive instance newtypeCoords :: Newtype Coords _
derive instance genCoords :: Generic Coords _
instance decCoords :: Decode Coords where
  decode = genericDecode opts
instance showCoords :: Show Coords where
  show = genericShow

newtype Building = Building { coordinates :: Array Coords }
derive instance newtypeBuilding :: Newtype Building _
derive instance genBuilding :: Generic Building _
instance decBuilding :: Decode Building where
  decode = genericDecode opts
instance showBuilding :: Show Building where
  show = genericShow


unBuilding :: Building -> Array { x :: Number, y :: Number, z :: Number }
unBuilding (Building {coordinates}) = (\(Coords c) -> c) <$> coordinates