module Pure3.Scene where

import Prelude
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Array (concat)

import Pure3.Point (Point)
import Pure3.Line (Line)
import Pure3.Line as Line
import Pure3.Square (Square(..))

type Mesh = Array Point

data Scene = Scene 
  { points :: Array Point
  , lines ::  Array Line
  , squares :: Array Square
  , meshes :: Array Mesh
}

derive instance genScene :: Generic Scene _
instance showScene :: Show Scene where show = genericShow

-- Transforms an scene to a list of points and lines...
-- Reduces squares to lines
-- In the future shapes could carry representation information to
-- decide which interpolation/transform function to use
-- so we could represent an square as a list of lines or as a list of points
-- maybe even both?

-- for now we will represent an square as a list of 4 lines
-- so we need to create lines from the points of an square

squareToLines :: Square -> Array Line
squareToLines (Square {a,b,c,d}) = 
  let lab = Line.create a b
      lbd = Line.create b d
      ldc = Line.create d c
      lca = Line.create c a
  in [lab, lbd, ldc, lca]

-- create parses the squares to lines, this should be a row type I think
create :: 
  { points :: Array Point
  , lines :: Array Line
  , squares :: Array Square
  , meshes ::  Array Mesh } -> Scene

create scene = 
  let squares' = map squareToLines scene.squares 
  in 
    Scene 
    { points: scene.points
    , lines: scene.lines <> concat squares'
    , squares: []
    , meshes: scene.meshes
    }

-- This is not needed anymore...
-- unfoldScene :: Scene -> { points :: Array Point, lines :: Array Line }
-- unfoldScene (Scene s) = s
