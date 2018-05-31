module Pure3.Line where

import Prelude (class Show)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Newtype (class Newtype)

import Pure3.Point (Point)

newtype Line = Line { a :: Point, b :: Point}
derive instance genLine :: Generic Line _
instance showLine :: Show Line where
  show = genericShow
derive instance newtypeLine :: Newtype Line _  

create :: Point -> Point -> Line
create a b = Line { a: a, b: b}

-- [NEWTYPE]
