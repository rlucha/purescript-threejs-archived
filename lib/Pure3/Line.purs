module Pure3.Line where

import Prelude (class Show)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Newtype (class Newtype, unwrap)

import Pure3.Point (Point) as P

newtype Line = Line { a :: P.Point, b :: P.Point}
derive instance genLine :: Generic Line _
instance showLine :: Show Line where
  show = genericShow
derive instance newtypeLine :: Newtype Line _  

create :: P.Point -> P.Point -> Line
create a b = Line { a: a, b: b}
